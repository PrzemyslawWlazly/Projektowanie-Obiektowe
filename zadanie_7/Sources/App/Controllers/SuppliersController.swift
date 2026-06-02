import Fluent // Importujemy Fluent, aby wykonywac CRUD dostawcow w bazie danych.
import Vapor // Importujemy Vapor, aby tworzyc kontroler, trasy i widoki.

struct SupplierForm: Content { // Struktura odbiera dane formularza dostawcy.
    var name: String // Nazwa dostawcy przeslana przez uzytkownika.
    var email: String // Email dostawcy przeslany przez uzytkownika.
    var phone: String // Telefon dostawcy przeslany przez uzytkownika.
}

struct SupplierViewData: Content { // Struktura przygotowuje dostawce do wyswietlenia w Leaf.
    var id: String // Id dostawcy jako tekst uzywany w linkach.
    var name: String // Nazwa dostawcy wyswietlana w tabeli.
    var email: String // Email dostawcy wyswietlany w tabeli.
    var phone: String // Telefon dostawcy wyswietlany w tabeli.
}

struct SuppliersIndexContext: Content { // Kontekst listy dostawcow.
    var suppliers: [SupplierViewData] // Dostawcy przygotowani do wyswietlenia.
}

struct SupplierFormContext: Content { // Kontekst formularza dostawcy.
    var title: String // Tytul formularza.
    var action: String // Adres zapisu formularza.
    var submitLabel: String // Tekst przycisku zapisu.
    var name: String // Aktualna albo pusta nazwa dostawcy.
    var email: String // Aktualny albo pusty email dostawcy.
    var phone: String // Aktualny albo pusty telefon dostawcy.
}

struct SupplierDetailsContext: Content { // Kontekst szczegolow dostawcy.
    var supplier: SupplierViewData // Jeden dostawca przygotowany do wyswietlenia.
}

struct SuppliersController: RouteCollection { // RouteCollection grupuje trasy dostawcow.
    func boot(routes: RoutesBuilder) throws { // Metoda boot rejestruje widoki HTML i API JSON.
        let suppliers = routes.grouped("suppliers") // Grupa /suppliers obsluguje widoki Leaf.
        suppliers.get(use: indexView) // GET /suppliers pokazuje liste dostawcow.
        suppliers.get("new", use: createView) // GET /suppliers/new pokazuje formularz tworzenia.
        suppliers.post(use: createFromForm) // POST /suppliers zapisuje nowego dostawce.
        suppliers.group(":supplierID") { supplier in // Grupa z id obsluguje jednego dostawce.
            supplier.get(use: showView) // GET /suppliers/:supplierID pokazuje szczegoly.
            supplier.get("edit", use: editView) // GET /suppliers/:supplierID/edit pokazuje formularz edycji.
            supplier.post("update", use: updateFromForm) // POST /suppliers/:supplierID/update zapisuje edycje.
            supplier.post("delete", use: deleteFromForm) // POST /suppliers/:supplierID/delete usuwa dostawce.
        }

        let api = routes.grouped("api", "suppliers") // Grupa /api/suppliers obsluguje JSON.
        api.get(use: indexAPI) // GET /api/suppliers zwraca liste dostawcow.
        api.post(use: createAPI) // POST /api/suppliers tworzy dostawce.
        api.group(":supplierID") { supplier in // Grupa z id obsluguje jednego dostawce w API.
            supplier.get(use: showAPI) // GET /api/suppliers/:supplierID zwraca jednego dostawce.
            supplier.put(use: updateAPI) // PUT /api/suppliers/:supplierID aktualizuje dostawce.
            supplier.delete(use: deleteAPI) // DELETE /api/suppliers/:supplierID usuwa dostawce.
        }
    }

    func indexView(req: Request) async throws -> View { // Funkcja renderuje liste dostawcow.
        let suppliers = try await supplierRows(on: req) // Pobieramy dostawcow z bazy.
        return try await req.view.render("suppliers/index", SuppliersIndexContext(suppliers: suppliers)) // Renderujemy szablon listy.
    }

    func createView(req: Request) async throws -> View { // Funkcja renderuje formularz nowego dostawcy.
        let context = SupplierFormContext(title: "Nowy dostawca", action: "/suppliers", submitLabel: "Dodaj dostawce", name: "", email: "", phone: "") // Tworzymy pusty formularz.
        return try await req.view.render("suppliers/form", context) // Renderujemy formularz dostawcy.
    }

    func createFromForm(req: Request) async throws -> Response { // Funkcja zapisuje dostawce z formularza HTML.
        let form = try req.content.decode(SupplierForm.self) // Dekodujemy dane formularza.
        let supplier = Supplier(name: form.name, email: form.email, phone: form.phone) // Tworzymy model dostawcy.
        try await supplier.save(on: req.db) // Zapisujemy dostawce przez Fluent.
        return req.redirect(to: "/suppliers") // Wracamy na liste dostawcow.
    }

    func showView(req: Request) async throws -> View { // Funkcja pokazuje szczegoly dostawcy.
        let supplier = try await findSupplier(on: req) // Pobieramy dostawce z bazy.
        return try await req.view.render("suppliers/show", SupplierDetailsContext(supplier: supplierViewData(from: supplier))) // Renderujemy szczegoly.
    }

    func editView(req: Request) async throws -> View { // Funkcja renderuje formularz edycji dostawcy.
        let supplier = try await findSupplier(on: req) // Pobieramy dostawce.
        let context = SupplierFormContext(title: "Edycja dostawcy", action: "/suppliers/\(try supplier.requireID())/update", submitLabel: "Zapisz zmiany", name: supplier.name, email: supplier.email, phone: supplier.phone) // Tworzymy wypelniony formularz.
        return try await req.view.render("suppliers/form", context) // Renderujemy formularz dostawcy.
    }

    func updateFromForm(req: Request) async throws -> Response { // Funkcja zapisuje edycje dostawcy.
        let supplier = try await findSupplier(on: req) // Pobieramy istniejacego dostawce.
        let form = try req.content.decode(SupplierForm.self) // Dekodujemy formularz edycji.
        apply(form, to: supplier) // Przepisujemy dane formularza na model.
        try await supplier.save(on: req.db) // Zapisujemy zmiany w bazie.
        return req.redirect(to: "/suppliers") // Wracamy na liste dostawcow.
    }

    func deleteFromForm(req: Request) async throws -> Response { // Funkcja usuwa dostawce z formularza.
        let supplier = try await findSupplier(on: req) // Pobieramy dostawce do usuniecia.
        try await supplier.delete(on: req.db) // Usuwamy dostawce z bazy.
        return req.redirect(to: "/suppliers") // Wracamy na liste dostawcow.
    }

    func indexAPI(req: Request) async throws -> [Supplier] { // Funkcja zwraca dostawcow jako JSON.
        try await Supplier.query(on: req.db).all() // Pobieramy wszystkich dostawcow.
    }

    func createAPI(req: Request) async throws -> Supplier { // Funkcja tworzy dostawce z JSON-a.
        let form = try req.content.decode(SupplierForm.self) // Dekodujemy dane JSON.
        let supplier = Supplier(name: form.name, email: form.email, phone: form.phone) // Tworzymy model dostawcy.
        try await supplier.save(on: req.db) // Zapisujemy dostawce.
        return supplier // Zwracamy zapisanego dostawce.
    }

    func showAPI(req: Request) async throws -> Supplier { // Funkcja zwraca jednego dostawce jako JSON.
        try await findSupplier(on: req) // Pobieramy dostawce albo rzucamy blad.
    }

    func updateAPI(req: Request) async throws -> Supplier { // Funkcja aktualizuje dostawce przez JSON.
        let supplier = try await findSupplier(on: req) // Pobieramy istniejacego dostawce.
        let form = try req.content.decode(SupplierForm.self) // Dekodujemy nowe dane.
        apply(form, to: supplier) // Aktualizujemy pola modelu.
        try await supplier.save(on: req.db) // Zapisujemy zmiany.
        return supplier // Zwracamy zmienionego dostawce.
    }

    func deleteAPI(req: Request) async throws -> HTTPStatus { // Funkcja usuwa dostawce przez API.
        let supplier = try await findSupplier(on: req) // Pobieramy dostawce.
        try await supplier.delete(on: req.db) // Usuwamy dostawce.
        return .noContent // Zwracamy status 204.
    }

    private func apply(_ form: SupplierForm, to supplier: Supplier) { // Funkcja pomocnicza przepisuje pola formularza.
        supplier.name = form.name // Aktualizujemy nazwe dostawcy.
        supplier.email = form.email // Aktualizujemy email dostawcy.
        supplier.phone = form.phone // Aktualizujemy telefon dostawcy.
    }

    private func supplierRows(on req: Request) async throws -> [SupplierViewData] { // Funkcja przygotowuje liste dostawcow.
        let suppliers = try await Supplier.query(on: req.db).sort(\.$name).all() // Pobieramy dostawcow posortowanych po nazwie.
        return suppliers.map { supplierViewData(from: $0) } // Zamieniamy modele na dane widoku.
    }

    private func supplierViewData(from supplier: Supplier) -> SupplierViewData { // Funkcja zamienia model na dane Leaf.
        SupplierViewData(id: supplier.id?.uuidString ?? "", name: supplier.name, email: supplier.email, phone: supplier.phone) // Zwracamy prosta strukture widoku.
    }

    private func findSupplier(on req: Request) async throws -> Supplier { // Funkcja znajduje dostawce po id ze sciezki.
        guard let supplierID = req.parameters.get("supplierID", as: UUID.self) else { // Odczytujemy UUID ze sciezki.
            throw Abort(.badRequest, reason: "Nieprawidlowe id dostawcy.") // Bledne id oznacza blad 400.
        }

        guard let supplier = try await Supplier.find(supplierID, on: req.db) else { // Szukamy dostawcy w bazie.
            throw Abort(.notFound, reason: "Dostawca nie zostal znaleziony.") // Brak dostawcy oznacza blad 404.
        }

        return supplier // Zwracamy znalezionego dostawce.
    }
}
