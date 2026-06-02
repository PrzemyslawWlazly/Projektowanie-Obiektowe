import Fluent // Importujemy Fluent, aby zmienic istniejaca tabele produktow.

struct AddCategoryToProduct: AsyncMigration { // Migracja dopisuje relacje produktu do kategorii.
    func prepare(on database: Database) async throws { // prepare wykonuje zmiane struktury tabeli.
        try await database.schema(Product.schema) // Wybieramy istniejaca tabele products.
            .field("category_id", .uuid, .references(Category.schema, "id", onDelete: .setNull)) // Dodajemy opcjonalny klucz obcy do kategorii.
            .update() // Aktualizujemy tabele products bez usuwania danych.
    }

    func revert(on database: Database) async throws { // revert cofa dodanie relacji.
        try await database.schema(Product.schema) // Wybieramy tabele products.
            .deleteField("category_id") // Usuwamy kolumne category_id.
            .update() // Zapisujemy cofniecie zmiany w tabeli.
    }
}
