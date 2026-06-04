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
