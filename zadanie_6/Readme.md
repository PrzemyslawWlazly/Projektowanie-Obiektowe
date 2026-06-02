# Zadanie 6 - Zapaszki

Projekt bazuje na aplikacji z `zadanie_5`. W ramach tego zestawu przygotowano konfigurację pre-commit oraz poprawiono problemy wykryte przez Sonar w kodzie aplikacji klienckiej i w plikach wspierających uruchomienie projektu.

## Spełnione wymagania

✅ **3.0**  
Skonfigurowano `husky` oraz `lint-staged`, aby przed commitem uruchamiać lintowanie plików JS/JSX.

Pliki:
- `frontend/package.json`
- `frontend/package-lock.json`
- `frontend/.husky/pre-commit`

✅ **3.5**  
Usunięto problemy zgłoszone przez Sonar dla aplikacji z `zadanie_5`.

Poprawki:
- dodano `backend/go.sum`, aby wersje zależności Go były przewidywalne,
- usunięto logowanie danych kontrolowanych przez użytkownika w `backend/main.go`,
- dodano walidację propsów w mockach React Routera w `frontend/src/App.test.js`,
- dodano walidację `children` w `frontend/src/context/AppContext.js`,
- zastąpiono `role="status"` elementem `output` w `frontend/src/components/Payments.js`,
- zastąpiono `instanceof Function` bezpieczniejszym sprawdzeniem `typeof` w `frontend/src/reportWebVitals.js`,
- dodano normalizację danych produktów z API przed zapisaniem ich w stanie Reacta,
- zastąpiono usuwanie pozycji koszyka po indeksie stabilnym identyfikatorem pozycji.

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
