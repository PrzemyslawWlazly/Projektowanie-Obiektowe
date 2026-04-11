
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
