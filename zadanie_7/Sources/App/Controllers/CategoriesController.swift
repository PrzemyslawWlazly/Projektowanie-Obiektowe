import Fluent // Importujemy Fluent, aby wykonywac CRUD kategorii w bazie danych.
import Vapor // Importujemy Vapor, aby tworzyc kontroler i renderowac widoki.

struct CategoryForm: Content { // Struktura odbiera dane z formularza kategorii.
    var name: String // Nazwa kategorii przeslana przez uzytkownika.
    var description: String // Opis kategorii przeslany przez uzytkownika.
}

struct CategoryViewData: Content { // Struktura przygotowuje kategorie do wyswietlenia w HTML.
    var id: String // Id kategorii jako tekst uzywany w linkach.
    var name: String // Nazwa kategorii wyswietlana w tabeli.
    var description: String // Opis kategorii wyswietlany w tabeli.
    var productsCount: Int // Liczba produktow przypisanych do kategorii.
}

struct CategoriesIndexContext: Content { // Kontekst strony listy kategorii.
    var categories: [CategoryViewData] // Kategorie przygotowane do wyswietlenia.
}

struct CategoryFormContext: Content { // Kontekst formularza kategorii.
    var title: String // Tytul strony formularza.
    var action: String // Adres zapisu formularza.
    var submitLabel: String // Tekst przycisku zapisu.
    var name: String // Aktualna albo pusta nazwa kategorii.
    var description: String // Aktualny albo pusty opis kategorii.
}

struct CategoryDetailsContext: Content { // Kontekst strony szczegolow kategorii.
    var category: CategoryViewData // Kategoria przygotowana do wyswietlenia.
    var products: [ProductViewData] // Produkty nalezace do tej kategorii.
}

struct CategoriesController: RouteCollection { // RouteCollection grupuje trasy kategorii.
    func boot(routes: RoutesBuilder) throws { // Metoda boot rejestruje trasy HTML i API.
        let categories = routes.grouped("categories") // Grupa /categories obsluguje widoki Leaf.
        categories.get(use: indexView) // GET /categories pokazuje liste kategorii.
        categories.get("new", use: createView) // GET /categories/new pokazuje formularz dodawania.
        categories.post(use: createFromForm) // POST /categories zapisuje nowa kategorie.
        categories.group(":categoryID") { category in // Grupa z id obsluguje jedna kategorie.
            category.get(use: showView) // GET /categories/:categoryID pokazuje szczegoly kategorii.
            category.get("edit", use: editView) // GET /categories/:categoryID/edit pokazuje formularz edycji.
            category.post("update", use: updateFromForm) // POST /categories/:categoryID/update zapisuje edycje.
            category.post("delete", use: deleteFromForm) // POST /categories/:categoryID/delete usuwa kategorie.
        }

        let api = routes.grouped("api", "categories") // Grupa /api/categories obsluguje JSON.
        api.get(use: indexAPI) // GET /api/categories zwraca kategorie jako JSON.
        api.post(use: createAPI) // POST /api/categories tworzy kategorie.
        api.group(":categoryID") { category in // Grupa z id obsluguje jedna kategorie w API.
            category.get(use: showAPI) // GET /api/categories/:categoryID zwraca jedna kategorie.
            category.put(use: updateAPI) // PUT /api/categories/:categoryID aktualizuje kategorie.
            category.delete(use: deleteAPI) // DELETE /api/categories/:categoryID usuwa kategorie.
        }
    }

    func indexView(req: Request) async throws -> View { // Funkcja renderuje liste kategorii.
        let rows = try await categoryRows(on: req) // Pobieramy dane kategorii do tabeli.
        return try await req.view.render("categories/index", CategoriesIndexContext(categories: rows)) // Renderujemy szablon listy.
    }

    func createView(req: Request) async throws -> View { // Funkcja renderuje formularz nowej kategorii.
        let context = CategoryFormContext(title: "Nowa kategoria", action: "/categories", submitLabel: "Dodaj kategorie", name: "", description: "") // Tworzymy pusty formularz.
        return try await req.view.render("categories/form", context) // Renderujemy formularz kategorii.
    }

    func createFromForm(req: Request) async throws -> Response { // Funkcja zapisuje kategorie z formularza.
        let form = try req.content.decode(CategoryForm.self) // Dekodujemy dane formularza.
        let category = Category(name: form.name, description: form.description) // Tworzymy model kategorii.
        try await category.save(on: req.db) // Zapisujemy kategorie przez Fluent.
        return req.redirect(to: "/categories") // Wracamy na liste kategorii.
    }

    func showView(req: Request) async throws -> View { // Funkcja pokazuje szczegoly kategorii.
        let category = try await findCategoryWithProducts(on: req) // Pobieramy kategorie z produktami.
        let products = category.products.map { product in // Zamieniamy produkty kategorii na dane widoku.
            ProductViewData(id: product.id?.uuidString ?? "", name: product.name, description: product.description, price: product.price, stock: product.stock, categoryName: category.name) // Tworzymy wiersz produktu.
        }
        let context = CategoryDetailsContext(category: categoryViewData(from: category), products: products) // Tworzymy kontekst szczegolow.
        return try await req.view.render("categories/show", context) // Renderujemy szablon szczegolow.
    }

    func editView(req: Request) async throws -> View { // Funkcja renderuje formularz edycji kategorii.
        let category = try await findCategory(on: req) // Pobieramy kategorie.
        let context = CategoryFormContext(title: "Edycja kategorii", action: "/categories/\(try category.requireID())/update", submitLabel: "Zapisz zmiany", name: category.name, description: category.description) // Tworzymy wypelniony formularz.
        return try await req.view.render("categories/form", context) // Renderujemy formularz kategorii.
    }

    func updateFromForm(req: Request) async throws -> Response { // Funkcja zapisuje edycje kategorii.
        let category = try await findCategory(on: req) // Pobieramy istniejaca kategorie.
        let form = try req.content.decode(CategoryForm.self) // Dekodujemy dane formularza.
        category.name = form.name // Aktualizujemy nazwe kategorii.
        category.description = form.description // Aktualizujemy opis kategorii.
        try await category.save(on: req.db) // Zapisujemy zmiany w bazie.
        return req.redirect(to: "/categories") // Wracamy na liste kategorii.
    }

    func deleteFromForm(req: Request) async throws -> Response { // Funkcja usuwa kategorie.
        let category = try await findCategory(on: req) // Pobieramy kategorie do usuniecia.
        try await category.delete(on: req.db) // Usuwamy kategorie, a produkty traca relacje przez onDelete setNull.
        return req.redirect(to: "/categories") // Wracamy na liste kategorii.
    }

    func indexAPI(req: Request) async throws -> [Category] { // Funkcja zwraca wszystkie kategorie jako JSON.
        try await Category.query(on: req.db).with(\.$products).all() // Pobieramy kategorie z produktami.
    }

    func createAPI(req: Request) async throws -> Category { // Funkcja tworzy kategorie z JSON-a.
        let form = try req.content.decode(CategoryForm.self) // Dekodujemy dane JSON.
        let category = Category(name: form.name, description: form.description) // Tworzymy model kategorii.
        try await category.save(on: req.db) // Zapisujemy kategorie.
        return category // Zwracamy zapisana kategorie.
    }

    func showAPI(req: Request) async throws -> Category { // Funkcja zwraca jedna kategorie jako JSON.
        try await findCategoryWithProducts(on: req) // Pobieramy kategorie z produktami.
    }

    func updateAPI(req: Request) async throws -> Category { // Funkcja aktualizuje kategorie przez JSON.
        let category = try await findCategory(on: req) // Pobieramy istniejaca kategorie.
        let form = try req.content.decode(CategoryForm.self) // Dekodujemy nowe dane.
        category.name = form.name // Aktualizujemy nazwe.
        category.description = form.description // Aktualizujemy opis.
        try await category.save(on: req.db) // Zapisujemy zmiany.
        return category // Zwracamy zmieniona kategorie.
    }

    func deleteAPI(req: Request) async throws -> HTTPStatus { // Funkcja usuwa kategorie przez API.
        let category = try await findCategory(on: req) // Pobieramy kategorie.
        try await category.delete(on: req.db) // Usuwamy kategorie.
        return .noContent // Zwracamy status 204.
    }

    private func categoryRows(on req: Request) async throws -> [CategoryViewData] { // Funkcja przygotowuje kategorie do listy.
        let categories = try await Category.query(on: req.db).with(\.$products).sort(\.$name).all() // Pobieramy kategorie z produktami.
        return categories.map { categoryViewData(from: $0) } // Mapujemy modele na dane widoku.
    }

    private func categoryViewData(from category: Category) -> CategoryViewData { // Funkcja tworzy prosty opis kategorii dla Leaf.
        CategoryViewData(id: category.id?.uuidString ?? "", name: category.name, description: category.description, productsCount: category.products.count) // Zwracamy dane kategorii.
    }

    private func findCategory(on req: Request) async throws -> Category { // Funkcja znajduje kategorie po id.
        guard let categoryID = req.parameters.get("categoryID", as: UUID.self) else { // Odczytujemy UUID ze sciezki.
            throw Abort(.badRequest, reason: "Nieprawidlowe id kategorii.") // Bledny UUID oznacza blad 400.
        }

        guard let category = try await Category.find(categoryID, on: req.db) else { // Szukamy kategorii w bazie.
            throw Abort(.notFound, reason: "Kategoria nie zostala znaleziona.") // Brak kategorii oznacza blad 404.
        }

        return category // Zwracamy znaleziona kategorie.
    }

    private func findCategoryWithProducts(on req: Request) async throws -> Category { // Funkcja znajduje kategorie z produktami.
        guard let categoryID = req.parameters.get("categoryID", as: UUID.self) else { // Odczytujemy UUID ze sciezki.
            throw Abort(.badRequest, reason: "Nieprawidlowe id kategorii.") // Bledny UUID oznacza blad 400.
        }

        guard let category = try await Category.query(on: req.db).filter(\.$id == categoryID).with(\.$products).first() else { // Pobieramy kategorie z produktami.
            throw Abort(.notFound, reason: "Kategoria nie zostala znaleziona.") // Brak kategorii oznacza blad 404.
        }

        return category // Zwracamy kategorie z relacja.
    }
}
