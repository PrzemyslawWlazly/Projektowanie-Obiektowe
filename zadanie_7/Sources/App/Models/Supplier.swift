import Fluent // Importujemy Fluent, aby dostawca mogl byc modelem ORM.
import Vapor // Importujemy Vapor, aby dostawca mogl byc zwracany jako JSON.

final class Supplier: Model, Content { // Supplier reprezentuje dostawce produktow dla sklepu.
    static let schema = "suppliers" // Nazwa schema okresla tabele suppliers w bazie danych.

    @ID(key: .id) // Pole id jest kluczem glownym rekordu dostawcy.
    var id: UUID? // Id jest opcjonalne przed pierwszym zapisem do bazy.

    @Field(key: "name") // Pole name bedzie kolumna name w tabeli suppliers.
    var name: String // Nazwa dostawcy, np. hurtownia albo producent.

    @Field(key: "email") // Pole email bedzie kolumna email w tabeli suppliers.
    var email: String // Email pozwala kontaktowac sie z dostawca.

    @Field(key: "phone") // Pole phone bedzie kolumna phone w tabeli suppliers.
    var phone: String // Telefon pozwala szybko skontaktowac sie z dostawca.

    init() { } // Pusty inicjalizator jest wymagany przez Fluent.

    init(id: UUID? = nil, name: String, email: String, phone: String) { // Inicjalizator pomocniczy ulatwia tworzenie dostawcy.
        self.id = id // Przypisujemy opcjonalne id dostawcy.
        self.name = name // Przypisujemy nazwe dostawcy.
        self.email = email // Przypisujemy email dostawcy.
        self.phone = phone // Przypisujemy telefon dostawcy.
    }
}
