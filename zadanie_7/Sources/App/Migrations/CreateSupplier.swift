import Fluent // Importujemy Fluent, aby opisac migracje tabeli dostawcow.

struct CreateSupplier: AsyncMigration { // Migracja tworzy i usuwa tabele suppliers.
    func prepare(on database: Database) async throws { // prepare wykonuje migracje w gore.
        try await database.schema(Supplier.schema) // Wybieramy schemat, czyli tabele suppliers.
            .id() // Dodajemy glowny klucz UUID.
            .field("name", .string, .required) // Dodajemy wymagana nazwe dostawcy.
            .field("email", .string, .required) // Dodajemy wymagany email dostawcy.
            .field("phone", .string, .required) // Dodajemy wymagany telefon dostawcy.
            .create() // Tworzymy tabele suppliers.
    }

    func revert(on database: Database) async throws { // revert cofa migracje dostawcow.
        try await database.schema(Supplier.schema) // Wybieramy tabele suppliers.
            .delete() // Usuwamy tabele suppliers.
    }
}
