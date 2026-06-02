import Fluent // Importujemy Fluent, aby stworzyc migracje bazy danych.

struct CreateProduct: AsyncMigration { // Migracja opisuje zmiany wykonywane na strukturze bazy danych.
    func prepare(on database: Database) async throws { // prepare uruchamia sie podczas komendy migrate.
        try await database.schema(Product.schema) // Wskazujemy tabele, ktora chcemy utworzyc.
            .id() // Dodajemy domyslny klucz glowny id typu UUID.
            .field("name", .string, .required) // Dodajemy wymagana kolumne z nazwa produktu.
            .field("description", .string, .required) // Dodajemy wymagana kolumne z opisem produktu.
            .field("price", .double, .required) // Dodajemy wymagana kolumne z cena produktu.
            .field("stock", .int, .required) // Dodajemy wymagana kolumne ze stanem magazynowym.
            .create() // Wykonujemy utworzenie tabeli w bazie danych.
    }

    func revert(on database: Database) async throws { // revert cofa migracje, gdy chcemy usunac utworzona strukture.
        try await database.schema(Product.schema) // Wskazujemy tabele produktow do usuniecia.
            .delete() // Usuwamy tabele products z bazy danych.
    }
}
