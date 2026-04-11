// Deklaracja pakietu, w którym znajduje się nasz kontroler, aby utrzymać porządek w projekcie.
package com.hogwarts.auth

// Importujemy adnotację Lazy, niezbędną do opóźnionego wstrzykiwania zależności w konstruktorze.
import org.springframework.context.annotation.Lazy
// Importujemy GetMapping do obsługi zapytań HTTP typu GET (zazwyczaj pobieranie danych).
import org.springframework.web.bind.annotation.GetMapping
// Importujemy PostMapping do obsługi zapytań HTTP typu POST (zazwyczaj wysyłanie danych, np. formularz logowania).
import org.springframework.web.bind.annotation.PostMapping
// Importujemy RequestBody, aby Spring automatycznie mapował JSON z żądania do obiektu Kotlina.
import org.springframework.web.bind.annotation.RequestBody
// Importujemy RequestMapping do zdefiniowania głównego, bazowego adresu URL dla całej klasy kontrolera.
import org.springframework.web.bind.annotation.RequestMapping
// Importujemy RestController, który informuje Springa, że ta klasa to kontroler REST i ma zwracać JSONy.
import org.springframework.web.bind.annotation.RestController

// Klasa danych (Data Class) reprezentująca użytkownika. Będzie używana jako format wyjściowy w endpoincie GET.
data class UserData(val id: Int, val username: String, val role: String)

// Klasa danych reprezentująca żądanie logowania. Przechwyci login i hasło przesyłane w formacie JSON przez użytkownika.
data class LoginRequest(val username: String, val password: String)

// Oznaczamy klasę adnotacją @RestController, aby framework Spring wziął ją pod swoje skrzydła.
@RestController
// Ustawiamy globalny przedrostek ścieżki dla wszystkich adresów w tym kontrolerze na "/api".
@RequestMapping("/api")
// Definiujemy główną klasę kontrolera i od razu w nawiasach otwieramy jej główny konstruktor.
class AuthController(
    // Wstrzykujemy standardowy serwis autoryzacji. Ponieważ nie ma adnotacji @Lazy, Spring utworzy go natychmiast (Eager).
    private val authService: AuthService,
    
    // KLUCZOWY PUNKT 5.0: Dodajemy adnotację @Lazy przed parametrem! Dzięki temu Spring nie utworzy go przy starcie aplikacji...
    // ...zamiast tego wstrzyknie tu "pustą wydmuszkę" (proxy), a prawdziwy obiekt powstanie dopiero przy pierwszym użyciu jego metody.
    @Lazy private val lazyAuthService: LazyAuthService
// Zamykamy definicję konstruktora i otwieramy nawias klamrowy rozpoczynający ciało klasy AuthController.
) {

    // Tworzymy prywatną (private), niezmienną (val) listę użytkowników, która symuluje działanie bazy danych do punktu 3.0.
    private val mockUsers = listOf(
        // Pierwszy obiekt użytkownika: Harry Potter z domu Gryffindor.
        UserData(1, "harry_p", "Gryffindor"),
        // Drugi obiekt użytkownika: Hermiona Granger z domu Gryffindor.
        UserData(2, "hermiona_g", "Gryffindor"),
        // Trzeci obiekt użytkownika: Draco Malfoy z domu Slytherin.
        UserData(3, "draco_m", "Slytherin")
    // Zamykamy funkcję tworzącą listę 'listOf'.
    )

    // Oznaczamy metodę adnotacją @GetMapping z adresem "/users". Pełny adres tego endpointu to "/api/users".
    @GetMapping("/users")
    // Definiujemy funkcję getUsers, wskazując, że jej typem zwracanym będzie lista obiektów UserData (List<UserData>).
    fun getUsers(): List<UserData> {
        // Po prostu zwracamy naszą statyczną listę mockUsers. Spring automatycznie zamieni to na tablicę w formacie JSON.
        return mockUsers
    // Zamykamy ciało funkcji getUsers.
    }

    // Oznaczamy metodę adnotacją @PostMapping z adresem "/login/eager". Będzie ona testować nasz zwykły, "zachłanny" Singleton.
    @PostMapping("/login/eager")
    // Definiujemy funkcję loginEager. Przechwytuje ona ciało zapytania (@RequestBody) i rzutuje je na nasz obiekt LoginRequest. Zwraca typ String.
    fun loginEager(@RequestBody request: LoginRequest): String {
        // Wywołujemy metodę authenticate na standardowym (Eager) serwisie. Przekazujemy mu nazwę użytkownika i hasło z żądania.
        val isAuthenticated = authService.authenticate(request.username, request.password)
        
        // Zwracamy wynik używając instrukcji warunkowej if jako wyrażenia (w Kotlinie if może zwracać wartość).
        return if (isAuthenticated) {
            // Jeśli authService zwrócił true (dane były poprawne), zwracamy komunikat sukcesu dla wersji Eager.
            "EAGER: Zalogowano pomyślnie! Witaj, ${request.username}."
        // Słowo kluczowe else określające, co ma się stać, gdy if otrzyma z serwisu wartość false.
        } else {
            // Jeśli dane były błędne, zwracamy komunikat błędu dla testu Eager.
            "EAGER: Błąd."
        // Zamykamy blok instrukcji warunkowej if/else.
        }
    // Zamykamy ciało funkcji loginEager.
    }

    // Oznaczamy metodę adnotacją @PostMapping z adresem "/login/lazy". Będzie ona obsługiwać nasz leniwie tworzony Singleton.
    @PostMapping("/login/lazy")
    // Definiujemy funkcję loginLazy, działającą analogicznie jak ta wyżej, przyjmującą parametry z JSONa w postaci LoginRequest. Zwraca typ String.
    fun loginLazy(@RequestBody request: LoginRequest): String {
        // Używamy lazyAuthService! Ponieważ użyliśmy adnotacji @Lazy w konstruktorze, to dokładnie w tej linijce...
        // ...przy pierwszym wywołaniu, Spring zorientuje się, że potrzebuje serwisu i dopiero TERAZ go utworzy, co zobaczymy w logach konsoli.
        val isAuthenticated = lazyAuthService.authenticate(request.username, request.password)
        
        // Zwracamy odpowiedź tekstową w zależności od poprawności danych logowania (czy uwierzytelniono z sukcesem).
        return if (isAuthenticated) {
            // Wstawiamy nazwę zalogowanego użytkownika do stringa komunikatu o sukcesie.
            "LAZY: Zalogowano pomyślnie! Witaj, ${request.username}."
        // Otwieramy blok else dla przypadku podania np. błędnego hasła.
        } else {
            // Zwracamy tekst z informacją o błędzie logowania w wariancie leniwym.
            "LAZY: Błąd."
        // Zamykamy blok warunkowy if/else.
        }
    // Zamykamy ciało funkcji loginLazy.
    }
// Zamykamy całkowicie ciało klasy kontrolera (AuthController).
}
