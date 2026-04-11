package proxy // Deklaracja pakietu proxy

import ( // Rozpoczęcie bloku importów
	"encoding/json" // Import do parsowania JSON-a z zewnętrznego API
	"errors"        // Import do tworzenia niestandardowych błędów
	"fmt"           // Import do formatowania ciągów znaków (np. budowania URL-a)
	"net/http"      // Import do wykonywania zapytań HTTP
	"zestaw_4/models" // Import naszych modeli
) // Zakończenie bloku importów

type OpenMeteoResponse struct { // Struktura pomocnicza do odebrania danych
	CurrentWeather struct { // Zagnieżdżony obiekt pogody
		Temperature float64 `json:"temperature"` // Wyciągamy tylko temperaturę
	} `json:"current_weather"` // Odpowiada kluczowi z JSON-a od Open-Meteo
} // Zakończenie struktury

type WeatherProxy struct{} // Klasa (struktura) proxy

func (p *WeatherProxy) GetWeatherFromAPI(city string) (models.Weather, error) { // Metoda pobierająca dane dla konkretnego miasta
	coords := map[string]string{ // Słownik mapujący nazwy miast na ich współrzędne geograficzne
		"Warszawa": "latitude=52.2298&longitude=21.0118", // Współrzędne Warszawy
		"Kraków":   "latitude=50.0614&longitude=19.9366", // Współrzędne Krakowa
		"Gdańsk":   "latitude=54.3520&longitude=18.6466", // Współrzędne Gdańska
	} // Zakończenie inicjalizacji mapy

	coord, exists := coords[city] // Sprawdzenie, czy podane miasto znajduje się w naszym słowniku
	if !exists { // Jeśli miasta nie ma na liście...
		return models.Weather{}, errors.New("nie obsługujemy jeszcze tego miasta") // Zwracamy błąd o braku obsługi
	} // Zakończenie warunku

	url := fmt.Sprintf("https://api.open-meteo.com/v1/forecast?%s&current_weather=true", coord) // Budowanie adresu URL z wykorzystaniem odpowiednich współrzędnych

	resp, err := http.Get(url) // Wykonanie zapytania HTTP do Open-Meteo
	if err != nil { // Obsługa ewentualnego błędu połączenia
		return models.Weather{}, err // Zwrócenie błędu
	} // Zakończenie warunku
	defer resp.Body.Close() // Zamknięcie strumienia pamięci po wyjściu z funkcji

	var apiResponse OpenMeteoResponse // Deklaracja zmiennej na odpowiedź z API
	if err := json.NewDecoder(resp.Body).Decode(&apiResponse); err != nil { // Dekodowanie JSON-a
		return models.Weather{}, err // Zwrócenie błędu w razie problemów z parsowaniem
	} // Zakończenie warunku

	weather := models.Weather{ // Stworzenie ostatecznego obiektu z wynikami
		City:        city, // Przypisanie miasta
		Temperature: apiResponse.CurrentWeather.Temperature, // Przypisanie pobranej temperatury
		Description: "Dane z API (Live)", // Informacja o świeżości danych
	} // Zakończenie obiektu

	return weather, nil // Zwrócenie sukcesu
} // Zakończenie funkcji
