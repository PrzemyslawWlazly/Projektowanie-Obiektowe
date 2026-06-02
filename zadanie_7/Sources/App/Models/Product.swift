import Fluent // Importujemy Fluent, aby model mogl byc zapisany w bazie danych.
import Vapor // Importujemy Vapor, aby model mogl byc kodowany i dekodowany jako tresc HTTP.

final class Product: Model, Content { // Product jest modelem ORM oraz typem przyjmowanym i zwracanym w JSON.
    static let schema = "products" // Nazwa schema okresla tabele w bazie danych.

    @ID(key: .id) // Pole id jest kluczem glownym automatycznie obslugiwanym przez Fluent.
    var id: UUID? // Identyfikator produktu jest opcjonalny przed pierwszym zapisem do bazy.

    @Field(key: "name") // Pole name bedzie kolumna name w tabeli products.
    var name: String // Nazwa produktu opisuje, co sprzedajemy w sklepie.

    @Field(key: "description") // Pole description bedzie kolumna description w tabeli products.
    var description: String // Opis produktu pozwala podac wiecej informacji klientowi.

    @Field(key: "price") // Pole price bedzie kolumna price w tabeli products.
    var price: Double // Cena produktu jest liczba zmiennoprzecinkowa.

    @Field(key: "stock") // Pole stock bedzie kolumna stock w tabeli products.
    var stock: Int // Stan magazynowy informuje, ile sztuk produktu jest dostepnych.

    @OptionalParent(key: "category_id") // Relacja opcjonalna laczy produkt z jedna kategoria.
    var category: Category? // Kategoria grupuje produkty w sklepie, np. elektronika albo ksiazki.

    init() { } // Pusty inicjalizator jest wymagany przez Fluent do tworzenia obiektow z bazy.

    init(id: UUID? = nil, name: String, description: String, price: Double, stock: Int, categoryID: UUID? = nil) { // Inicjalizator pomocniczy ulatwia tworzenie produktu w kodzie.
        self.id = id // Przypisujemy opcjonalne id, jesli zostalo przekazane.
        self.name = name // Przypisujemy nazwe produktu.
        self.description = description // Przypisujemy opis produktu.
        self.price = price // Przypisujemy cene produktu.
        self.stock = stock // Przypisujemy stan magazynowy produktu.
        self.$category.id = categoryID // Przypisujemy opcjonalne id kategorii dla relacji.
    }
}
