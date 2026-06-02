import Vapor // Importujemy Vapor, aby miec dostep do Application i funkcji uruchamiania serwera.

@main // Atrybut @main wskazuje miejsce startu programu.
enum Entrypoint { // Enum pelni role prostego kontenera dla funkcji main.
    static func main() async throws { // Funkcja main uruchamia sie jako pierwsza po starcie aplikacji.
        var env = try Environment.detect() // Vapor odczytuje srodowisko, np. development albo production.
        try LoggingSystem.bootstrap(from: &env) // Konfigurujemy logowanie na podstawie ustawien srodowiska.
        let app = Application(env) // Tworzymy instancje aplikacji Vapor.
        defer { app.shutdown() } // Po zakonczeniu pracy zwalniamy zasoby aplikacji.
        try configure(app) // Wywolujemy konfiguracje bazy danych, migracji i tras.
        try await app.execute() // Startujemy serwer i czekamy na przychodzace zapytania HTTP.
    }
}
