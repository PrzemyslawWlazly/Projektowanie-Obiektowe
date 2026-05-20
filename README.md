## Zadanie 1

✅ 3.0 Procedura do generowania 50 losowych liczb od 0 do 100   
✅ 3.5 Procedura do sortowania liczb  
✅ 4.0 Dodanie parametrów do procedury losującej określającymi zakres  
losowania: od, do, ile  
✅ 4.5 5 testów jednostkowych testujące procedury  
✅ 5.0 Skrypt w bashu do uruchamiania aplikacji w Pascalu via docker  

Wszystko znajduje się w jednym pliku obrazu
 [link do obrazu](https://hub.docker.com/r/przemyslawwlazly/pascal-app)  


 Kod: [link do zadania 1](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/tree/main/projekt_1)  


 -------------------------------------------

 ## Zadanie 2: Wzorce architektury - Symfony (PHP)

[Link do głównego folderu projektu](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/tree/main/projekt_2)

✅ **3.0 Należy stworzyć jeden model z kontrolerem z produktami, zgodnie z CRUD (JSON)**
* [Kod modelu: Product.php](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_2/src/Entity/Product.php)
* [Kod kontrolera API: ApiProductController.php](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_2/src/Controller/ApiProductController.php)

✅ **3.5 Należy stworzyć skrypty do testów endpointów via curl (JSON)**
* [Skrypt testowy: test_api.sh](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_2/testy/test_api.sh)

✅ **4.0 Należy stworzyć dwa dodatkowe kontrolery wraz z modelami (JSON)**
* [Model kategorii: Category.php](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_2/src/Entity/Category.php) | [Kontroler API kategorii: ApiCategoryController.php](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_2/src/Controller/ApiCategoryController.php)
* [Model opinii: Review.php](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_2/src/Entity/Review.php) | [Kontroler API opinii: ApiReviewController.php](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_2/src/Controller/ApiReviewController.php)

✅ **4.5 Należy stworzyć widoki do wszystkich kontrolerów**
* [Widoki produktów (Twig)](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/tree/main/projekt_2/templates/product)
* [Widoki kategorii (Twig)](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/tree/main/projekt_2/templates/category)
* [Widoki opinii (Twig)](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/tree/main/projekt_2/templates/review)

❌ **5.0 Stworzenie panelu administracyjnego**
* *(Nie zrealizowano)*

---

### Instrukcja uruchomienia:
1. **Uruchomienie kontenera:**
   `docker run -it -p 8000:8000 -v $(pwd):/home/student/projobj kprzystalski/projobj-php:latest`
2. **Wejście do folderu projektu:**
   `cd projekt_2`
3. **Uruchomienie serwera Symfony:**
   `symfony server:start -d`
4. **Uruchomienie testów API (cURL):**
   `./testy/test_api.sh`

<img width="686" height="296" alt="Screenshot from 2026-04-10 23-09-41" src="https://github.com/user-attachments/assets/7463b5c5-ec6e-44aa-b9ea-c84310370c71" />

<img width="686" height="296" alt="Screenshot from 2026-04-10 23-09-45" src="https://github.com/user-attachments/assets/073a8c8b-fd33-4dc3-9d69-3aa7be2d4a1e" />

<img width="686" height="296" alt="Screenshot from 2026-04-10 23-09-48" src="https://github.com/user-attachments/assets/c2a49e02-3cc7-469a-85ba-466a97982ad2" />

[Screencast from 2026-04-10 23-51-28.webm](https://github.com/user-attachments/assets/d8f1b331-5247-476d-94ff-d06900c6d1f2)

--------------------------------------

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

[Screencast from 2026-04-11 19-23-33.webm](https://github.com/user-attachments/assets/51b0d4f5-c7a3-4b79-88a8-623d9c318917)
<img width="1642" height="566" alt="Screenshot from 2026-04-11 19-24-48" src="https://github.com/user-attachments/assets/fa284de6-16bd-4197-b0d3-9e98ac6b5724" />


--------------------------------------

## Zadanie 4: Wzorce strukturalne - Echo (Go)

[Link do głównego folderu projektu](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/tree/main/projekt_4)

✅ **3.0 Należy stworzyć aplikację we frameworki echo w j. Go, która będzie miała kontroler Pogody, która pozwala na pobieranie danych o pogodzie**
* [Punkt wejścia aplikacji: main.go](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_4/main.go)
* [Kod kontrolera API: weather_controller.go](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_4/controllers/weather_controller.go)

✅ **3.5 Należy stworzyć model Pogoda wykorzystując gorm, a dane załadować z listy przy uruchomieniu**
* [Model bazy danych: weather.go](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_4/models/weather.go)
* [Logika bazy (GORM, SQLite, ładowanie z listy): db.go](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_4/database/db.go)

✅ **4.0 Należy stworzyć klasę proxy, która pobierze dane z serwisu zewnętrznego podczas zapytania do naszego kontrolera**
* [Klasa Proxy (Open-Meteo API): weather_proxy.go](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_4/proxy/weather_proxy.go)

✅ **4.5 Należy zapisać pobrane dane z zewnątrz do bazy danych**
* [Logika zapisu/aktualizacji w kontrolerze: weather_controller.go](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_4/controllers/weather_controller.go)

✅ **5.0 Należy rozszerzyć endpoint na więcej niż jedną lokalizację zwracając JSONa**
* [Rozszerzone wsparcie miast (współrzędne): weather_proxy.go](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_4/proxy/weather_proxy.go)
* [Obsługa parametrów zapytania URL: weather_controller.go](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/projekt_4/controllers/weather_controller.go)

[ FILM ](https://github.com/user-attachments/assets/94b68d87-1be7-4596-9f7e-04591818a80c)


<img width="1639" height="976" alt="Screenshot from 2026-04-11 22-24-15" src="https://github.com/user-attachments/assets/9215230b-b8c7-4f4d-9e89-7eda17cf518c" />

----------------------------------------


-----------------------------------------
Zadanie 5 (Oddane jako zadanie 5 dla przedmiotu EBiznes 11.04)

# Zadanie 5 Frontend

✅ **3.0** W ramach projektu stworzono dwa komponenty: Produkty oraz Płatności. Komponent [Products.js](https://github.com/PrzemyslawWlazly/EBiznes/blob/main/zestaw_5/frontend/src/components/Products.js) pobiera dane o asortymencie, natomiast [Payments.js](https://github.com/PrzemyslawWlazly/EBiznes/blob/main/zestaw_5/frontend/src/components/Payments.js) wysyła dane o płatnościach do serwera.

✅ **3.5** Dodano komponent [Cart.js](https://github.com/PrzemyslawWlazly/EBiznes/blob/main/zestaw_5/frontend/src/components/Cart.js) (Koszyk) wraz z dedykowanym widokiem. Do nawigacji między podstronami wykorzystano bibliotekę `react-router-dom`, skonfigurowaną w pliku [App.js](https://github.com/PrzemyslawWlazly/EBiznes/blob/main/zestaw_5/frontend/src/App.js).

✅ **4.0** Dane pomiędzy wszystkimi komponentami (produkty, stan koszyka, suma płatności) są przesyłane za pomocą React Hooks oraz Context API, co zostało zaimplementowane w pliku [AppContext.js](https://github.com/PrzemyslawWlazly/EBiznes/blob/main/zestaw_5/frontend/src/context/AppContext.js).

✅ **4.5** Przygotowano skrypt [docker-compose.yml](https://github.com/PrzemyslawWlazly/EBiznes/blob/main/zestaw_5/docker-compose.yml), który automatycznie buduje i uruchamia aplikację serwerową (Go) oraz kliencką (React).
- [Link do obrazu Frontend](https://hub.docker.com/r/przemyslawwlazly/esy-floresy-frontend)
- [Link do obrazu Backend](https://hub.docker.com/r/przemyslawwlazly/esy-floresy-backend)

❌ **5.0** Aplikacja serwerowa w języku Go nie została wyposażona w nagłówki obsługujące CORS 

[Link do całego zadania 5](https://github.com/PrzemyslawWlazly/EBiznes/tree/main/zestaw_5)




[EBiznes_zestaw5.webm](https://github.com/user-attachments/assets/d96a3c2c-6581-4abd-a75c-ff8f781f137d)
