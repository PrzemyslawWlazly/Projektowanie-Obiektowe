## Zadanie 3: Wzorce kreacyjne - Spring Boot (Kotlin)

[Link do głównego folderu projektu](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/tree/main/projekt_3)

✅ **3.0 Należy stworzyć jeden kontroler wraz z danymi wyświetlanymi z listy na endpoint’cie w formacie JSON - Kotlin + Spring Boot**
* [Kod kontrolera API: AuthController.kt](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_3/src/main/kotlin/com/hogwarts/auth/AuthController.kt)

✅ **3.5 Należy stworzyć klasę do autoryzacji (mock) jako Singleton w formie eager**
* [Kod serwisu (Eager Singleton): AuthService.kt](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_3/src/main/kotlin/com/hogwarts/auth/AuthService.kt)

✅ **4.0 Należy obsłużyć dane autoryzacji przekazywane przez użytkownika**
* [Obsługa danych logowania (LoginRequest): AuthController.kt](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_3/src/main/kotlin/com/hogwarts/auth/AuthController.kt)

✅ **4.5 Należy wstrzyknąć singleton do głównej klasy via @Autowired lub kontruktor (constructor injection)**
* [Wstrzykiwanie przez konstruktor: AuthController.kt](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_3/src/main/kotlin/com/hogwarts/auth/AuthController.kt)

✅ **5.0 Obok wersji Eager do wyboru powinna być wersja Singletona w wersji lazy**
* [Kod serwisu (Lazy Singleton): LazyAuthService.kt](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_3/src/main/kotlin/com/hogwarts/auth/LazyAuthService.kt)
* [Użycie adnotacji @Lazy w kontrolerze: AuthController.kt](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_3/src/main/kotlin/com/hogwarts/auth/AuthController.kt)

---

### Instrukcja uruchomienia:

1. **Wejście do folderu projektu:**
   ```bash
   cd projekt_3

2. Uruchomienie serwera Spring Boot (wymaga zainstalowanej Javy 17):
    Bash

    ./gradlew bootRun

    (Poczekaj, aż w logach pojawi się informacja: Tomcat started on port 8080)

3. Testowanie endpointów (w osobnej karcie terminala):

Pobieranie listy użytkowników (Punkt 3.0):
  

    curl http://localhost:8080/api/users

Testowanie autoryzacji z Singletonem Eager (Punkty 4.0 i 4.5):
    

    curl -X POST http://localhost:8080/api/login/eager -H "Content-Type: application/json" -d '{"username":"harry_p", "password":"lumos"}'

Testowanie autoryzacji z Singletonem Lazy (Punkt 5.0):
    

    curl -X POST http://localhost:8080/api/login/lazy -H "Content-Type: application/json" -d '{"username":"harry_p", "password":"lumos"}'

    (Przy pierwszym wywołaniu endpointu Lazy, w oknie terminala z uruchomionym serwerem pojawi się komunikat o utworzeniu nowej instancji serwisu).

[FILM ](https://github.com/user-attachments/assets/51b0d4f5-c7a3-4b79-88a8-623d9c318917)
  
  
oraz SCREEN  
<img width="1642" height="566" alt="Screenshot from 2026-04-11 19-24-48" src="https://github.com/user-attachments/assets/fa284de6-16bd-4197-b0d3-9e98ac6b5724" />
