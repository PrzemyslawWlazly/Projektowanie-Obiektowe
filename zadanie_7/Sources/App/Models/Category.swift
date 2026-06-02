import Fluent // Importujemy Fluent, aby kategoria mogla byc modelem ORM.
import Vapor // Importujemy Vapor, aby kategoria mogla byc kodowana i dekodowana w zapytaniach.

final class Category: Model, Content { // Category reprezentuje kategorie produktow w sklepie.
    static let schema = "categories" // Nazwa schema okresla tabele kategorii w bazie danych.

    @ID(key: .id) // Pole id jest glownym identyfikatorem kategorii.
    var id: UUID? // Id jest opcjonalne przed zapisaniem kategorii do bazy.

    @Field(key: "name") // Pole name bedzie kolumna name w tabeli categories.
    var name: String // Nazwa kategorii, np. Elektronika.

    @Field(key: "description") // Pole description bedzie kolumna description w tabeli categories.
    var description: String // Opis kategorii wyjasnia, jakie produkty do niej pasuja.

    @Children(for: \.$category) // Relacja jeden-do-wielu pokazuje produkty nalezace do kategorii.
    var products: [Product] // Kategoria moze miec wiele produktow.

    init() { } // Pusty inicjalizator jest wymagany przez Fluent.

    init(id: UUID? = nil, name: String, description: String) { // Inicjalizator pomocniczy pozwala latwo tworzyc kategorie.
        self.id = id // Przypisujemy opcjonalne id kategorii.
        self.name = name // Przypisujemy nazwe kategorii.
        self.description = description // Przypisujemy opis kategorii.
    }
}
