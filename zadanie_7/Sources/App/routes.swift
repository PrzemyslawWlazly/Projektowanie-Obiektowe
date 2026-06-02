import Vapor // Importujemy Vapor, aby definiowac trasy aplikacji.

func routes(_ app: Application) throws { // Funkcja routes rejestruje wszystkie kontrolery i endpointy.
    app.get { req async throws in // Definiujemy trase GET / jako strone startowa aplikacji.
        try await req.view.render("home") // Renderujemy szablon home.leaf jako glowny ekran sklepu.
    }

    try app.register(collection: ProductsController()) // Rejestrujemy kontroler obslugujacy CRUD produktow.
    try app.register(collection: CategoriesController()) // Rejestrujemy kontroler obslugujacy CRUD kategorii.
    try app.register(collection: SuppliersController()) // Rejestrujemy kontroler obslugujacy CRUD dostawcow.
    try app.register(collection: RedisController()) // Rejestrujemy kontroler pokazujacy dane zapisane w Redis.
}
