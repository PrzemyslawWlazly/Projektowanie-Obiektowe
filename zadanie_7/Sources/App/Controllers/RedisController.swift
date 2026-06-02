import Redis // Importujemy Redis, aby odczytac dane zapisane w magazynie Redis.
import Vapor // Importujemy Vapor, aby zdefiniowac trasy kontrolera.

struct RedisStatusContext: Content { // Kontekst strony pokazujacej stan Redis.
    var productsJSON: String // Tekst JSON zapisany w Redis pod kluczem listy produktow.
    var lastUpdate: String // Data ostatniego zapisu cache produktow.
}

struct RedisController: RouteCollection { // Kontroler grupuje trasy zwiazane z Redis.
    func boot(routes: RoutesBuilder) throws { // Metoda boot rejestruje trasy Redis.
        let redis = routes.grouped("redis") // Wszystkie trasy zaczynaja sie od /redis.
        redis.get(use: statusView) // GET /redis pokazuje dane zapisane w Redis jako strone HTML.
        redis.get("products", use: productsJSON) // GET /redis/products zwraca surowy JSON z Redis.
    }

    func statusView(req: Request) async throws -> View { // Funkcja renderuje widok stanu Redis.
        let products = try await readRedisValue("shop:products:list", on: req) // Odczytujemy liste produktow z Redis.
        let lastUpdate = try await readRedisValue("shop:products:last_update", on: req) // Odczytujemy czas ostatniej aktualizacji.
        let context = RedisStatusContext(productsJSON: products, lastUpdate: lastUpdate) // Tworzymy kontekst widoku.
        return try await req.view.render("redis/index", context) // Renderujemy szablon Redis.
    }

    func productsJSON(req: Request) async throws -> String { // Funkcja zwraca zawartosc klucza Redis jako tekst.
        try await readRedisValue("shop:products:list", on: req) // Odczytujemy i zwracamy liste produktow.
    }

    private func readRedisValue(_ key: String, on req: Request) async throws -> String { // Funkcja pomocnicza odczytuje pojedynczy klucz Redis.
        try await req.redis.get(RedisKey(key), as: String.self).get() ?? "Brak danych w Redis dla klucza \(key)." // Zwracamy wartosc albo komunikat o braku.
    }
}
