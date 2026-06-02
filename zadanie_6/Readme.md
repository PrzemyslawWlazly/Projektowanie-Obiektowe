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

❌ **4.0 Przeskanować oraz naprawić dowolny projekt open source narzędziem CodeQL**  

❌ **4.5 Należy usunąć problemy typu Code Smell w kodzie w Sonarze (kotlin, go, js). Należy dodać badge z Sonara**  

❌ **5.0 Skonfigurować Github Actions z linterem oraz CodeQL**  

## Uruchomienie lokalne

Backend:

```bash
cd backend
go run main.go
```

Frontend:

```bash
cd frontend
npm install
npm start
```

## Weryfikacja

Frontend:

```bash
cd frontend
npm run lint
npm test -- --watchAll=false
npm run build
```

Backend:

```bash
cd backend
go test ./...
```

## Docker

```bash
docker-compose up --build
```

Frontend będzie dostępny pod adresem `http://localhost:3000`, a backend pod adresem `http://localhost:8080`.
