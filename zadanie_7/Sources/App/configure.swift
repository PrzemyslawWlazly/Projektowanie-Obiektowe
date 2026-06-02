import Fluent // Importujemy Fluent, aby skonfigurowac baze danych i migracje.
import FluentSQLiteDriver // Importujemy sterownik SQLite uzywany przez lokalna baze danych.
import Leaf // Importujemy Leaf, aby Vapor umial renderowac szablony HTML.
import Redis // Importujemy Redis, aby aplikacja mogla laczyc sie z magazynem Redis.
import Vapor // Importujemy Vapor, aby pracowac na obiekcie Application.

public func configure(_ app: Application) throws { // Funkcja configure zbiera podstawowe ustawienia aplikacji.
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite) // Rejestrujemy lokalny plik db.sqlite jako baze danych SQLite.
    app.views.use(.leaf) // Ustawiamy Leaf jako domyslny silnik widokow HTML.
    app.redis.configuration = try RedisConfiguration(hostname: "localhost") // Konfigurujemy polaczenie z lokalnym Redis na standardowym porcie 6379.
    app.migrations.add(CreateCategory()) // Dodajemy migracje tworzaca tabele kategorii.
    app.migrations.add(CreateProduct()) // Dodajemy migracje tworzaca tabele produktow.
    app.migrations.add(CreateSupplier()) // Dodajemy migracje tworzaca tabele dostawcow.
    app.migrations.add(AddCategoryToProduct()) // Dodajemy migracje dopisujaca relacje produktu do kategorii.
    try routes(app) // Rejestrujemy trasy HTTP dostepne w aplikacji.
}
