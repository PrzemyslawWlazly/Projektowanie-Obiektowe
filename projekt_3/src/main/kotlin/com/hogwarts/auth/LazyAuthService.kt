// Deklaracja pakietu.
package com.hogwarts.auth

// Importujemy adnotację Lazy, która zmienia cykl życia Beana na "leniwy".
import org.springframework.context.annotation.Lazy
// Importujemy adnotację Service.
import org.springframework.stereotype.Service

// Oznaczamy klasę jako komponent zarządzany przez Springa.
@Service
// Dodajemy adnotację @Lazy. Spring nie stworzy tej klasy przy starcie, lecz dopiero przy pierwszym użyciu!
@Lazy
// Definiujemy klasę LazyAuthService.
class LazyAuthService {

    // Blok init w Kotlinie wykonuje się natychmiast podczas tworzenia instancji obiektu.
    init {
        // Wypisujemy wiadomość do konsoli, aby na własne oczy zobaczyć, KIEDY Spring tworzy ten obiekt.
        println("--- MAGIA: Tworzę instancję LazyAuthService (dopiero teraz, gdy jest potrzebna!) ---")
    // Zamykamy blok init.
    }

    // Metoda autoryzacji, identyczna jak w naszym wcześniejszym serwisie.
    fun authenticate(username: String, password: String): Boolean {
        // Zwracamy true, jeśli dane są poprawne, w przeciwnym razie false.
        return username == "harry_p" && password == "lumos"
    // Zamykamy ciało metody.
    }
// Zamykamy ciało klasy.
}
