import Fluent // Importujemy Fluent, aby wykonywac zapytania do bazy danych.
import Redis // Importujemy Redis, aby zapisywac dane produktow w magazynie klucz-wartosc.
import Vapor // Importujemy Vapor, aby tworzyc kontroler, trasy i odpowiedzi HTTP.

struct ProductForm: Content { // Struktura odbiera dane z formularza HTML albo z JSON-a.
    var name: String // Nazwa produktu wpisana przez uzytkownika.
    var description: String // Opis produktu wpisany przez uzytkownika.
    var price: Double // Cena produktu przeslana jako liczba.
    var stock: Int // Stan magazynowy przeslany jako liczba calkowita.
    var categoryID: String? // Id kategorii jest tekstem, bo pusty formularz moze wyslac pusta wartosc.
}

struct ProductViewData: Content { // Struktura przygotowuje produkt do bezpiecznego wyswietlenia w Leaf.
    var id: String // Id produktu jako tekst wygodny dla linkow HTML.
    var name: String // Nazwa produktu wyswietlana w tabeli.
    var description: String // Opis produktu wyswietlany na stronie.
    var price: Double // Cena produktu wyswietlana w tabeli.
    var stock: Int // Stan magazynowy wyswietlany w tabeli.
    var categoryName: String // Nazwa kategorii albo informacja o jej braku.
}

struct CategoryOptionData: Content { // Struktura opisuje jedna opcje w polu select formularza produktu.
    var id: String // Id kategorii jako wartosc atrybutu value.
    var name: String // Nazwa kategorii widoczna dla uzytkownika.
    var isSelected: Bool // Flaga mowi Leafowi, czy ta opcja ma byc zaznaczona.
}

struct ProductFormContext: Content { // Kontekst przekazywany do szablonu formularza produktu.
    var title: String // Tytul strony formularza.
    var action: String // Adres, pod ktory formularz wysyla dane.
    var submitLabel: String // Tekst przycisku zapisu.
    var name: String // Aktualna albo pusta nazwa produktu.
    var description: String // Aktualny albo pusty opis produktu.
    var price: Double // Aktualna albo domyslna cena produktu.
    var stock: Int // Aktualny albo domyslny stan magazynowy.
    var categories: [CategoryOptionData] // Lista kategorii dostepnych w polu wyboru.
}

struct ProductsIndexContext: Content { // Kontekst strony listy produktow.
    var products: [ProductViewData] // Produkty przygotowane do wyswietlenia.
}

struct ProductDetailsContext: Content { // Kontekst strony szczegolow produktu.
    var product: ProductViewData // Jeden produkt przygotowany do wyswietlenia.
}

struct ProductsController: RouteCollection { // RouteCollection grupuje trasy dotyczace produktow.
    func boot(routes: RoutesBuilder) throws { // Metoda boot rejestruje wszystkie adresy kontrolera.
        let products = routes.grouped("products") // Grupa /products obsluguje widoki Leaf.
        products.get(use: indexView) // GET /products pokazuje liste produktow w HTML.
        products.get("new", use: createView) // GET /products/new pokazuje formularz dodawania produktu.
        products.post(use: createFromForm) // POST /products zapisuje produkt z formularza HTML.
        products.group(":productID") { product in // Grupa z id obsluguje pojedynczy produkt w HTML.
            product.get(use: showView) // GET /products/:productID pokazuje szczegoly produktu.
            product.get("edit", use: editView) // GET /products/:productID/edit pokazuje formularz edycji.
            product.post("update", use: updateFromForm) // POST /products/:productID/update zapisuje edycje z formularza.
            product.post("delete", use: deleteFromForm) // POST /products/:productID/delete usuwa produkt z formularza.
        }

        let api = routes.grouped("api", "products") // Grupa /api/products zachowuje CRUD JSON dla pokazania Fluent API.
        api.get(use: indexAPI) // GET /api/products zwraca liste produktow jako JSON.
        api.post(use: createAPI) // POST /api/products tworzy produkt z JSON-a.
        api.group(":productID") { product in // Grupa z id obsluguje pojedynczy produkt w API.
            product.get(use: showAPI) // GET /api/products/:productID zwraca jeden produkt.
            product.put(use: updateAPI) // PUT /api/products/:productID aktualizuje produkt.
            product.delete(use: deleteAPI) // DELETE /api/products/:productID usuwa produkt.
        }
    }

    func indexView(req: Request) async throws -> View { // Funkcja renderuje liste produktow jako HTML.
        let products = try await productRows(on: req) // Pobieramy produkty razem z nazwami kategorii.
        return try await req.view.render("products/index", ProductsIndexContext(products: products)) // Renderujemy szablon listy.
    }

    func createView(req: Request) async throws -> View { // Funkcja renderuje formularz nowego produktu.
        let categories = try await categoryOptions(on: req, selectedID: nil) // Pobieramy kategorie do listy wyboru.
        let context = ProductFormContext(title: "Nowy produkt", action: "/products", submitLabel: "Dodaj produkt", name: "", description: "", price: 0, stock: 0, categories: categories) // Tworzymy dane formularza.
        return try await req.view.render("products/form", context) // Renderujemy wspolny formularz produktu.
    }

    func createFromForm(req: Request) async throws -> Response { // Funkcja zapisuje produkt przeslany formularzem HTML.
        let form = try req.content.decode(ProductForm.self) // Dekodujemy pola formularza.
        let product = Product(name: form.name, description: form.description, price: form.price, stock: form.stock, categoryID: parseCategoryID(form.categoryID)) // Budujemy model Product.
        try await product.save(on: req.db) // Zapisujemy produkt w bazie przez Fluent.
        await cacheProductsIfPossible(on: req) // Aktualizujemy kopie listy produktow w Redis.
        return req.redirect(to: "/products") // Wracamy na liste produktow.
    }

    func showView(req: Request) async throws -> View { // Funkcja renderuje szczegoly jednego produktu.
        let product = try await findProductWithCategory(on: req) // Pobieramy produkt razem z kategoria.
        let row = productViewData(from: product) // Zamieniamy model na dane widoku.
        return try await req.view.render("products/show", ProductDetailsContext(product: row)) // Renderujemy szablon szczegolow.
    }

    func editView(req: Request) async throws -> View { // Funkcja renderuje formularz edycji produktu.
        let product = try await findProduct(on: req) // Pobieramy produkt z bazy.
        let categories = try await categoryOptions(on: req, selectedID: product.$category.id) // Pobieramy kategorie i zaznaczamy aktualna.
        let context = ProductFormContext(title: "Edycja produktu", action: "/products/\(try product.requireID())/update", submitLabel: "Zapisz zmiany", name: product.name, description: product.description, price: product.price, stock: product.stock, categories: categories) // Tworzymy dane formularza.
        return try await req.view.render("products/form", context) // Renderujemy formularz produktu.
    }

    func updateFromForm(req: Request) async throws -> Response { // Funkcja zapisuje edycje przeslana formularzem HTML.
        let product = try await findProduct(on: req) // Pobieramy istniejacy produkt.
        let form = try req.content.decode(ProductForm.self) // Dekodujemy nowe dane formularza.
        apply(form, to: product) // Przepisujemy dane z formularza na model.
        try await product.save(on: req.db) // Zapisujemy zmieniony produkt w bazie.
        await cacheProductsIfPossible(on: req) // Aktualizujemy kopie produktow w Redis.
        return req.redirect(to: "/products") // Wracamy na liste produktow.
    }

    func deleteFromForm(req: Request) async throws -> Response { // Funkcja usuwa produkt po kliknieciu przycisku w HTML.
        let product = try await findProduct(on: req) // Pobieramy produkt do usuniecia.
        try await product.delete(on: req.db) // Usuwamy produkt z bazy.
        await cacheProductsIfPossible(on: req) // Aktualizujemy kopie listy w Redis.
        return req.redirect(to: "/products") // Wracamy na liste produktow.
    }

    func indexAPI(req: Request) async throws -> [Product] { // Funkcja zwraca produkty jako JSON.
        try await Product.query(on: req.db).with(\.$category).all() // Pobieramy produkty razem z relacja kategorii.
    }

    func createAPI(req: Request) async throws -> Product { // Funkcja tworzy produkt z JSON-a.
        let form = try req.content.decode(ProductForm.self) // Dekodujemy JSON do tej samej struktury co formularz.
        let product = Product(name: form.name, description: form.description, price: form.price, stock: form.stock, categoryID: parseCategoryID(form.categoryID)) // Tworzymy model produktu.
        try await product.save(on: req.db) // Zapisujemy produkt w bazie.
        await cacheProductsIfPossible(on: req) // Aktualizujemy Redis po zmianie danych.
        return product // Zwracamy zapisany produkt.
    }

    func showAPI(req: Request) async throws -> Product { // Funkcja zwraca jeden produkt jako JSON.
        try await findProductWithCategory(on: req) // Pobieramy produkt z kategoria albo rzucamy blad.
    }

    func updateAPI(req: Request) async throws -> Product { // Funkcja aktualizuje produkt z JSON-a.
        let product = try await findProduct(on: req) // Pobieramy istniejacy produkt.
        let form = try req.content.decode(ProductForm.self) // Dekodujemy nowe dane z JSON-a.
        apply(form, to: product) // Przepisujemy dane z JSON-a do modelu.
        try await product.save(on: req.db) // Zapisujemy zmiany.
        await cacheProductsIfPossible(on: req) // Aktualizujemy Redis po zmianie danych.
        return product // Zwracamy zmieniony produkt.
    }

    func deleteAPI(req: Request) async throws -> HTTPStatus { // Funkcja usuwa produkt przez API.
        let product = try await findProduct(on: req) // Pobieramy produkt do usuniecia.
        try await product.delete(on: req.db) // Usuwamy produkt z bazy.
        await cacheProductsIfPossible(on: req) // Aktualizujemy Redis po usunieciu.
        return .noContent // Zwracamy status 204 bez tresci.
    }

    private func apply(_ form: ProductForm, to product: Product) { // Funkcja pomocnicza aktualizuje pola modelu.
        product.name = form.name // Aktualizujemy nazwe.
        product.description = form.description // Aktualizujemy opis.
        product.price = form.price // Aktualizujemy cene.
        product.stock = form.stock // Aktualizujemy stan magazynowy.
        product.$category.id = parseCategoryID(form.categoryID) // Aktualizujemy opcjonalna relacje do kategorii.
    }

    private func parseCategoryID(_ rawValue: String?) -> UUID? { // Funkcja zamienia tekst z formularza na UUID.
        guard let rawValue, rawValue.isEmpty == false else { return nil } // Pusta wartosc oznacza brak kategorii.
        return UUID(uuidString: rawValue) // Poprawny tekst UUID zamieniamy na identyfikator.
    }

    private func productRows(on req: Request) async throws -> [ProductViewData] { // Funkcja pobiera produkty i tworzy dane do widoku.
        let products = try await Product.query(on: req.db).with(\.$category).all() // Pobieramy produkty z kategoriami.
        return products.map { productViewData(from: $0) } // Mapujemy modele na proste struktury widoku.
    }

    private func productViewData(from product: Product) -> ProductViewData { // Funkcja tworzy jeden wiersz tabeli produktu.
        ProductViewData(id: product.id?.uuidString ?? "", name: product.name, description: product.description, price: product.price, stock: product.stock, categoryName: product.category?.name ?? "Brak kategorii") // Zwracamy dane bez obiektow ORM.
    }

    private func categoryOptions(on req: Request, selectedID: UUID?) async throws -> [CategoryOptionData] { // Funkcja przygotowuje opcje selecta kategorii.
        let categories = try await Category.query(on: req.db).sort(\.$name).all() // Pobieramy kategorie posortowane po nazwie.
        return categories.compactMap { category in // Zamieniamy kazda kategorie na opcje formularza.
            guard let id = category.id else { return nil } // Kategorie bez id pomijamy, choc po zapisie nie powinno sie to zdarzyc.
            return CategoryOptionData(id: id.uuidString, name: category.name, isSelected: id == selectedID) // Tworzymy opcje selecta.
        }
    }

    private func findProduct(on req: Request) async throws -> Product { // Funkcja znajduje produkt po parametrze sciezki.
        guard let productID = req.parameters.get("productID", as: UUID.self) else { // Odczytujemy UUID ze sciezki.
            throw Abort(.badRequest, reason: "Nieprawidlowe id produktu.") // Gdy id jest bledne, zwracamy 400.
        }

        guard let product = try await Product.find(productID, on: req.db) else { // Szukamy produktu w bazie.
            throw Abort(.notFound, reason: "Produkt nie zostal znaleziony.") // Gdy produktu nie ma, zwracamy 404.
        }

        return product // Zwracamy znaleziony produkt.
    }

    private func findProductWithCategory(on req: Request) async throws -> Product { // Funkcja znajduje produkt razem z kategoria.
        guard let productID = req.parameters.get("productID", as: UUID.self) else { // Odczytujemy UUID ze sciezki.
            throw Abort(.badRequest, reason: "Nieprawidlowe id produktu.") // Bledny UUID oznacza blad 400.
        }

        guard let product = try await Product.query(on: req.db).filter(\.$id == productID).with(\.$category).first() else { // Pobieramy produkt z dolaczona kategoria.
            throw Abort(.notFound, reason: "Produkt nie zostal znaleziony.") // Brak produktu oznacza blad 404.
        }

        return product // Zwracamy produkt z relacja.
    }

    private func cacheProductsIfPossible(on req: Request) async { // Funkcja zapisuje liste produktow w Redis, gdy Redis dziala.
        do { // Uzywamy do-catch, aby brak Redis nie blokowal podstawowego CRUD.
            let rows = try await productRows(on: req) // Pobieramy aktualna liste produktow.
            let data = try JSONEncoder().encode(rows) // Kodujemy liste produktow do JSON-a.
            let json = String(data: data, encoding: .utf8) ?? "[]" // Zamieniamy dane JSON na tekst dla Redis.
            try await req.redis.set(RedisKey("shop:products:list"), to: json).get() // Zapisujemy liste produktow pod jednym kluczem Redis.
            try await req.redis.set(RedisKey("shop:products:last_update"), to: "\(Date())").get() // Zapisujemy czas ostatniej aktualizacji cache.
        } catch { // Gdy Redis nie dziala, tylko logujemy blad.
            req.logger.warning("Nie udalo sie zapisac danych produktow w Redis: \(error.localizedDescription)") // Log pomaga pokazac problem bez zatrzymywania aplikacji.
        }
    }
}
