// Pakiet
package com.hogwarts.auth

// Import
import org.springframework.stereotype.Service

// Oznaczamy jako Service (domyślnie Eager - zachłanny)
@Service
// Klasa AuthService
class AuthService {

    // Dodajemy blok init, aby zobaczyć w logach moment powstania tego obiektu.
    init {
        // Ten napis pojawi się w konsoli od razu po odpaleniu aplikacji.
        println("--- MAGIA: Tworzę instancję Eager AuthService (od razu przy starcie!) ---")
    // Zamykamy init
    }

    // Metoda logowania
    fun authenticate(username: String, password: String): Boolean {
        // Sprawdzamy dane
        return username == "harry_p" && password == "lumos"
    // Koniec metody
    }
// Koniec klasy
}
