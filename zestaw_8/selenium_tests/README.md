# Testy Selenium dla wymagań 3.0, 3.5, 4.0 i 4.5

Ten katalog zawiera testy WebDrivera sprawdzające formularz rejestracji użytkownika, odporność Reacta na XSS, spójność koszyka w kilku kartach tej samej przeglądarki oraz odporność ustawień konta na próbę CSRF.

## Uruchomienie

1. Jeżeli React zgłasza błąd `ENOSPC` przy watcherach, zwiększ limit systemowy:

```bash
sudo sysctl fs.inotify.max_user_watches=524288
sudo sysctl fs.inotify.max_user_instances=1024
```

2. Uruchom backend:

```bash
cd backend
go run main.go
```

3. Uruchom frontend:

```bash
cd frontend
npm install
npm start
```

4. W osobnym terminalu przygotuj środowisko Selenium:

```bash
cd selenium_tests
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
```

5. Uruchom testy Selenium w trybie headless:

```bash
APP_URL=http://localhost:3000 pytest -q
```

6. Jeżeli nagrywasz film i chcesz widzieć okno Chromium sterowane przez Selenium:

```bash
SHOW_BROWSER=1 APP_URL=http://localhost:3000 pytest -q
```

Testy wymagają zainstalowanej przeglądarki Chrome albo Chromium. Na Ubuntu z Chromium zainstalowanym jako snap testy korzystają z `/snap/bin/chromium.chromedriver` i osobnego profilu w `~/snap/chromium/common/selenium-profiles`, aby uniknąć błędu `SessionNotCreatedException`.

## Zakres testów

- `3.0`: walidacja pól obowiązkowych i niepoprawnego formatu e-maila w formularzu rejestracji.
- `3.5`: próba wstrzyknięcia payloadu XSS do pola nazwy użytkownika i sprawdzenie, że React renderuje go jako tekst.
- `4.0`: dodawanie i usuwanie produktów w koszyku przy dwóch otwartych kartach tej samej przeglądarki.
- `4.5`: logowanie użytkownika, legalna zmiana ustawień konta oraz próba wymuszenia zmiany przez spreparowany link z fałszywym tokenem CSRF.
