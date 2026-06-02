import Fluent // Importujemy Fluent, aby opisac migracje tabeli kategorii.

struct CreateCategory: AsyncMigration { // Migracja tworzy i usuwa tabele categories.
    func prepare(on database: Database) async throws { // prepare wykonuje sie podczas migracji w gore.
        try await database.schema(Category.schema) // Wybieramy schemat, czyli tabele categories.
            .id() // Dodajemy glowny klucz UUID.
            .field("name", .string, .required) // Dodajemy wymagana nazwe kategorii.
            .field("description", .string, .required) // Dodajemy wymagany opis kategorii.
            .unique(on: "name") // Wymuszamy unikalna nazwe kategorii, aby nie tworzyc duplikatow.
            .create() // Tworzymy tabele categories.
    }

    func revert(on database: Database) async throws { // revert wykonuje sie podczas cofania migracji.
        try await database.schema(Category.schema) // Wybieramy tabele categories.
            .delete() // Usuwamy tabele categories.
    }
}
