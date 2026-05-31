# Zadanie 5 - Wzorce behawioralne

Projekt zawiera aplikację React oraz backend Go realizujące wymagania od 3.0 do 5.0.

## Spełnione wymagania

✅ **3.0**  
Utworzono komponenty `Products` oraz `Payments`.  
`Products` uruchamia pobieranie danych produktów z backendu przez funkcję z `AppContext` i klienta `axios`.  
`Payments` wysyła dane płatności do backendu metodą `POST`.

Pliki:
- `frontend/src/components/Products.js`
- `frontend/src/components/Payments.js`
- `frontend/src/context/AppContext.js`
- `frontend/src/api/client.js`
- `backend/main.go`

✅ **3.5**  
Dodano komponent `Cart` jako osobny widok.  
Aplikacja umożliwia przechodzenie między widokami przez `react-router-dom`.

Pliki:
- `frontend/src/components/Cart.js`
- `frontend/src/App.js`

✅ **4.0**  
Dane między komponentami `Products`, `Cart` i `Payments` są przekazywane z użyciem React hooks oraz Context API.

Pliki:
- `frontend/src/context/AppContext.js`
- `frontend/src/components/Products.js`
- `frontend/src/components/Cart.js`
- `frontend/src/components/Payments.js`

✅ **4.5**  
Dodano konfigurację Docker dla aplikacji klienckiej i serwerowej oraz wspólne uruchamianie przez `docker-compose`.

Pliki:
- `docker-compose.yml`
- `frontend/Dockerfile`
- `backend/Dockerfile`

✅ **5.0**  
Frontend komunikuje się z backendem przez `axios`.  
Backend ma skonfigurowane nagłówki CORS dla zapytań z aplikacji React.

Pliki:
- `frontend/src/api/client.js`
- `frontend/src/context/AppContext.js`
- `frontend/src/components/Payments.js`
- `backend/main.go`

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

## Uruchomienie w Dockerze

```bash
docker-compose up --build
```

Frontend będzie dostępny pod adresem `http://localhost:3000`, a backend pod adresem `http://localhost:8080`.
