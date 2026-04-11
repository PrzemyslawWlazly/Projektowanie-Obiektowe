package controllers // Deklaracja pakietu controllers

import ( // Rozpoczęcie bloku importów
	"net/http" // Pakiet dla statusów HTTP
	"github.com/labstack/echo/v4" // Framework Echo
	"zestaw_4/database" // Pakiet bazy danych
	"zestaw_4/models" // Pakiet modeli
	"zestaw_4/proxy" // Pakiet proxy
) // Zakończenie bloku importów

func GetWeather(c echo.Context) error { // Funkcja endpointu
	city := c.QueryParam("city") // Pobranie wartości parametru 'city' z adresu URL (np. /weather?city=Kraków)

	if city == "" { // Jeśli użytkownik nie podał żadnego miasta w URL...
		var weathers []models.Weather // Tworzymy pustą tablicę na pogodę
		database.DB.Find(&weathers) // Pobieramy WSZYSTKIE rekordy z bazy (jak w punkcie 3.5)
		return c.JSON(http.StatusOK, weathers) // Zwracamy listę wszystkich miast z bazy
	} // Zakończenie obsługi zapytania bez parametru

	weatherProxy := proxy.WeatherProxy{} // Inicjalizacja proxy
	liveWeather, err := weatherProxy.GetWeatherFromAPI(city) // Próba pobrania danych z zewnątrz dla konkretnego miasta
	
	if err != nil { // Jeśli proxy zgłosi błąd (np. literówka w mieście lub brak obsługi)
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()}) // Zwracamy ładny błąd 400 (Bad Request)
	} // Zakończenie obsługi błędu z proxy

	var dbWeather models.Weather // Przygotowanie zmiennej na dane z bazy
	database.DB.Where("city = ?", city).First(&dbWeather) // Szukanie tego konkretnego miasta w naszej bazie
	
	if dbWeather.ID != 0 { // Jeśli miasto istnieje w bazie
		dbWeather.Temperature = liveWeather.Temperature // Aktualizujemy jego temperaturę
		dbWeather.Description = liveWeather.Description // Aktualizujemy opis
		database.DB.Save(&dbWeather) // Zapisujemy zmiany w SQLite
		liveWeather = dbWeather // Podmieniamy obiekt, żeby zwrócić właściwe ID w JSON
	} else { // W przeciwnym razie...
		database.DB.Create(&liveWeather) // Tworzymy nowy rekord w bazie
	} // Zakończenie bloku bazy danych
	
	return c.JSON(http.StatusOK, liveWeather) // Zwracamy pojedynczy obiekt (JSON) z danymi o wskazanym mieście
} // Zakończenie funkcji
