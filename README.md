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


-----------------------------------------

Zadanie 5 Wzorce behawioralne - React JavaScript/TypeScript

[Link do głównego folderu zadania 5](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/tree/main/zadanie_5)

✅ **3.0 W ramach projektu należy stworzyć komponenty Produkty oraz Płatności; komponent Produkty powinien pobierać listę produktów z aplikacji serwerowej, natomiast komponent Płatności powinien wysyłać dane płatności do aplikacji serwerowej**  
[link do obrazu Frontend na Docker Hub](https://hub.docker.com/r/przemyslawwlazly/zestaw5-frontend) | [link do obrazu Backend na Docker Hub](https://hub.docker.com/r/przemyslawwlazly/zestaw5-backend) | [kod rozwiązania: Products.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/frontend/src/components/Products.js), [Payments.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/frontend/src/components/Payments.js), [AppContext.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/frontend/src/context/AppContext.js), [client.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/frontend/src/api/client.js), [main.go](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/backend/main.go)

✅ **3.5 Należy dodać komponent Koszyk wraz z osobnym widokiem; aplikacja powinna umożliwiać przechodzenie pomiędzy widokami przy użyciu routingu**  
[link do obrazu Frontend na Docker Hub](https://hub.docker.com/r/przemyslawwlazly/zestaw5-frontend) | [kod rozwiązania: Cart.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/frontend/src/components/Cart.js), [App.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/frontend/src/App.js)

✅ **4.0 Dane pomiędzy komponentami, takimi jak Produkty, Koszyk i Płatności, powinny być przekazywane z wykorzystaniem React hooks, np. useState, useEffect lub useContext**  
[link do obrazu Frontend na Docker Hub](https://hub.docker.com/r/przemyslawwlazly/zestaw5-frontend) | [kod rozwiązania: AppContext.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/frontend/src/context/AppContext.js), [Products.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/frontend/src/components/Products.js), [Cart.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/frontend/src/components/Cart.js), [Payments.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/frontend/src/components/Payments.js)

✅ **4.5 Należy przygotować konfigurację umożliwiającą uruchomienie aplikacji klienckiej oraz serwerowej w kontenerach Docker za pomocą docker-compose**  
[link do obrazu Frontend na Docker Hub](https://hub.docker.com/r/przemyslawwlazly/zestaw5-frontend) | [link do obrazu Backend na Docker Hub](https://hub.docker.com/r/przemyslawwlazly/zestaw5-backend) | [kod rozwiązania: docker-compose.yml](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/docker-compose.yml), [frontend/Dockerfile](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/frontend/Dockerfile), [backend/Dockerfile](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/backend/Dockerfile)

✅ **5.0 Należy wykorzystać bibliotekę axios do komunikacji z serwerem oraz skonfigurować obsługę CORS, aby frontend mógł poprawnie komunikować się z backendem**  
[link do obrazu Frontend na Docker Hub](https://hub.docker.com/r/przemyslawwlazly/zestaw5-frontend) | [link do obrazu Backend na Docker Hub](https://hub.docker.com/r/przemyslawwlazly/zestaw5-backend) | [kod rozwiązania: client.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/frontend/src/api/client.js), [AppContext.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/frontend/src/context/AppContext.js), [Payments.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/frontend/src/components/Payments.js), [main.go](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_5/backend/main.go)


[PObiekt_zest5.webm](https://github.com/user-attachments/assets/8b4ff783-b35d-4674-8110-3292684d322a)


------------------------------
# Zadanie 6 - Zapaszki

[Link do głównego folderu zadania 6](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/tree/main/zadanie_6)

Projekt bazuje na aplikacji z `zadanie_5`. W ramach tego zestawu przygotowano konfigurację pre-commit oraz poprawiono problemy wykryte przez Sonar w kodzie aplikacji klienckiej i w plikach wspierających uruchomienie projektu.

## Spełnione wymagania

✅ **3.0 Należy skonfigurować husky + lint-staged uruchamianie lintowania przed commitem**  
[kod rozwiązania: package.json](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_6/frontend/package.json), [package-lock.json](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_6/frontend/package-lock.json), [pre-commit](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_6/frontend/.husky/pre-commit)

✅ **3.5 Należy wyeliminować wszystkie bugi w kodzie w Sonarze (kod aplikacji klienckiej)**  
[kod rozwiązania: go.sum](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_6/backend/go.sum), [main.go](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_6/backend/main.go), [App.test.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_6/frontend/src/App.test.js), [AppContext.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_6/frontend/src/context/AppContext.js), [Payments.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_6/frontend/src/components/Payments.js), [reportWebVitals.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_6/frontend/src/reportWebVitals.js), [Cart.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_6/frontend/src/components/Cart.js)

Poprawki:
- dodano `backend/go.sum`, aby wersje zależności Go były przewidywalne,
- usunięto logowanie danych kontrolowanych przez użytkownika w `backend/main.go`,
- dodano walidację propsów w mockach React Routera w `frontend/src/App.test.js`,
- dodano walidację `children` w `frontend/src/context/AppContext.js`,
- zastąpiono `role="status"` elementem `output` w `frontend/src/components/Payments.js`,
- zastąpiono `instanceof Function` bezpieczniejszym sprawdzeniem `typeof` w `frontend/src/reportWebVitals.js`,
- zastąpiono ogólne `new Error()` przez `new TypeError()` przy błędach walidacji typu danych,
- dodano normalizację danych produktów z API przed zapisaniem ich w stanie Reacta,
- zastąpiono usuwanie pozycji koszyka po indeksie stabilnym identyfikatorem pozycji.



<img width="908" height="659" alt="Screenshot from 2026-06-02 14-25-32" src="https://github.com/user-attachments/assets/409ee6b1-0017-4269-85c1-521f36721c4b" />
<img width="908" height="659" alt="Screenshot from 2026-06-02 14-24-39" src="https://github.com/user-attachments/assets/0b3abf87-a0fa-49a8-997d-19913d996213" />






❌ **4.0 Przeskanować oraz naprawić dowolny projekt open source narzędziem CodeQL**  

❌ **4.5 Należy usunąć problemy typu Code Smell w kodzie w Sonarze (kotlin, go, js). Należy dodać badge z Sonara**  

❌ **5.0 Skonfigurować Github Actions z linterem oraz CodeQL**  


---------------------------



## Zadanie 7: Vapor + Leaf + Fluent + Redis

[Link do głównego folderu projektu](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/tree/main/zadanie_7)

✅ **3.0 Należy stworzyć kontroler wraz z modelem Produktów zgodny z CRUD w ORM Fluent**
* [Model produktu: Product.swift](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Sources/App/Models/Product.swift)
* [Migracja produktu: CreateProduct.swift](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Sources/App/Migrations/CreateProduct.swift)
* [Kontroler produktów: ProductsController.swift](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Sources/App/Controllers/ProductsController.swift)

✅ **3.5 Należy stworzyć szablony w Leaf**
* [Strona główna Leaf: home.leaf](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Resources/Views/home.leaf)
* [Widoki produktów Leaf](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/tree/main/zadanie_7/Resources/Views/products)
* [Widok listy produktów: index.leaf](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Resources/Views/products/index.leaf)
* [Formularz produktu: form.leaf](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Resources/Views/products/form.leaf)
* [Widok szczegółów produktu: show.leaf](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Resources/Views/products/show.leaf)

✅ **4.0 Należy stworzyć drugi model oraz kontroler Kategorii wraz z relacją**
* [Model kategorii: Category.swift](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Sources/App/Models/Category.swift)
* [Migracja kategorii: CreateCategory.swift](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Sources/App/Migrations/CreateCategory.swift)
* [Migracja relacji produktu z kategorią: AddCategoryToProduct.swift](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Sources/App/Migrations/AddCategoryToProduct.swift)
* [Kontroler kategorii: CategoriesController.swift](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Sources/App/Controllers/CategoriesController.swift)
* [Widoki kategorii Leaf](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/tree/main/zadanie_7/Resources/Views/categories)

✅ **Dodatkowo: trzeci model wymagany w treści zadania**
* [Model dostawcy: Supplier.swift](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Sources/App/Models/Supplier.swift)
* [Migracja dostawcy: CreateSupplier.swift](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Sources/App/Migrations/CreateSupplier.swift)
* [Kontroler dostawców: SuppliersController.swift](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Sources/App/Controllers/SuppliersController.swift)
* [Widoki dostawców Leaf](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/tree/main/zadanie_7/Resources/Views/suppliers)

✅ **4.5 Należy wykorzystać Redis do przechowywania danych**
* [Konfiguracja Redis w aplikacji: configure.swift](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Sources/App/configure.swift)
* [Zapis produktów do Redis: ProductsController.swift](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Sources/App/Controllers/ProductsController.swift)
* [Kontroler podglądu danych Redis: RedisController.swift](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Sources/App/Controllers/RedisController.swift)
* [Widok danych Redis: redis/index.leaf](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zadanie_7/Resources/Views/redis/index.leaf)




[Obiektowe_zest7_45.webm](https://github.com/user-attachments/assets/6782584e-4f3c-4a13-bb1d-5113dfcc2579)

❌ **5.0 Wrzucić aplikację na Heroku**
* *(Nie zrealizowano)*

--------------------------------

## Zadanie 8: Selenium/WebDriver - testy aplikacji React

[Link do głównego folderu projektu](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/tree/main/zestaw_8)

✅ **3.0 Przetestuj formularz rejestracji użytkownika pod kątem walidacji pól obowiązkowych oraz zachowania aplikacji po wprowadzeniu niepoprawnego formatu adresu e-mail**
* [Formularz rejestracji: Register.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_8/frontend/src/components/Register.js)
* [Routing formularza rejestracji: App.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_8/frontend/src/App.js)
* [Testy Selenium walidacji formularza: test_registration_validation.py](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_8/selenium_tests/test_registration_validation.py)
* [Zależności testów Selenium: requirements.txt](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_8/selenium_tests/requirements.txt)

✅ **3.5 Przeprowadź testy bezpieczeństwa typu Cross-Site Scripting (XSS), próbując wstrzyknąć złośliwy kod JavaScript w aplikacji z Reactem**
* [Bezpieczne renderowanie danych użytkownika: Register.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_8/frontend/src/components/Register.js)
* [Test Selenium XSS: test_registration_validation.py](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_8/selenium_tests/test_registration_validation.py)

✅ **4.0 Przetestuj działanie koszyka zakupowego przy jednoczesnym otwarciu aplikacji w kilku osobnych kartach tej samej przeglądarki, sprawdzając spójność stanów zamówienia**
* [Synchronizacja koszyka przez localStorage i zdarzenie storage: AppContext.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_8/frontend/src/context/AppContext.js)
* [Widok produktów i dodawanie do koszyka: Products.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_8/frontend/src/components/Products.js)
* [Widok koszyka i usuwanie pozycji: Cart.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_8/frontend/src/components/Cart.js)
* [Test Selenium koszyka w kilku kartach: test_registration_validation.py](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_8/selenium_tests/test_registration_validation.py)

✅ **4.5 Do zadania z React'a należy dodać formularz logowania. Następnie przeprowadź testy podatności na ataki typu Cross-Site Request Forgery (CSRF), próbując wymusić nieautoryzowaną zmianę ustawień konta spreparowanym linkiem, podczas gdy użytkownik posiada aktywną sesję w innej karcie**
* [Formularz logowania: Login.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_8/frontend/src/components/Login.js)
* [Ustawienia konta chronione tokenem CSRF: AccountSettings.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_8/frontend/src/components/AccountSettings.js)
* [Obsługa sesji, tokenu CSRF i ustawień konta: AppContext.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_8/frontend/src/context/AppContext.js)
* [Routing logowania i ustawień konta: App.js](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_8/frontend/src/App.js)
* [Test Selenium CSRF: test_registration_validation.py](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_8/selenium_tests/test_registration_validation.py)

❌ **5.0 Stwórz scenariusz End-to-End w Playwright (minimum 50 asercji)**
* *(Nie zrealizowano)*

[Pr_Obiektowe_zest_chromium_45.webm](https://github.com/user-attachments/assets/1beebcd3-5964-479d-9943-ecff5c3784d4)


-----------------------


## Zadanie 9: Chmura, Docker i GitHub Actions

[Link do głównego folderu projektu](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/tree/main/zestaw_9)

✅ **3.0 Należy stworzyć odpowiednie instancje po stronie chmury na Dockerze**
* [Konfiguracja Docker Compose](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_9/docker-compose.yml)
* [Dockerfile aplikacji serwerowej](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_9/backend/Dockerfile)
* [Kod aplikacji serwerowej przygotowany do działania w chmurze](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_9/backend/main.go)
* [Dockerfile aplikacji klienckiej](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_9/frontend/Dockerfile)
* [Konfiguracja serwera Nginx](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_9/frontend/nginx.conf)
* [Uruchomiona aplikacja serwerowa na Render](https://zestaw9-backend.onrender.com/api/products)
* [Uruchomiona aplikacja kliencka na Render](https://zestaw9-frontend.onrender.com)

✅ **3.5 Stworzyć odpowiedni pipeline w GitHub Actions do budowania aplikacji**
* [Pipeline budujący obrazy Docker aplikacji klienckiej i serwerowej](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/.github/workflows/zestaw9-build.yml)
* [Historia uruchomień GitHub Actions](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/actions/workflows/zestaw9-build.yml)

✅ **4.0 Dodać notyfikację mailową o zbudowaniu aplikacji**
* [Konfiguracja powiadomienia e-mail w GitHub Actions](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/.github/workflows/zestaw9-build.yml)
* Dane logowania do serwera SMTP są przechowywane bezpiecznie jako sekrety repozytorium GitHub: `MAIL_USERNAME`, `MAIL_PASSWORD` oraz `MAIL_TO`.

✅ **4.5 Dodać krok z deploymentem aplikacji serwerowej oraz klienckiej na chmurę**
* [Kroki deploymentu backendu i frontendu na Render](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/.github/workflows/zestaw9-build.yml)
* Deployment jest uruchamiany po poprawnym zbudowaniu aplikacji za pomocą Render Deploy Hooks.
* Adresy hooków są przechowywane jako sekrety `RENDER_BACKEND_DEPLOY_HOOK` oraz `RENDER_FRONTEND_DEPLOY_HOOK`.
* [Wdrożony backend](https://zestaw9-backend.onrender.com/api/products)
* [Wdrożony frontend](https://zestaw9-frontend.onrender.com)

❌ **5.0 Dodać uruchomienie regresyjnych testów automatycznych (funkcjonalnych) jako krok w Actions**
* Punkt nie został zrealizowany.

