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

