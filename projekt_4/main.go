package main // Główny pakiet aplikacji

import ( // Rozpoczęcie bloku importów
	"github.com/labstack/echo/v4" // Import frameworka Echo
	"zestaw_4/controllers" // Import naszych kontrolerów
	"zestaw_4/database" // Import pakietu odpowiedzialnego za bazę danych
) // Zakończenie bloku importów

func main() { // Główna funkcja programu
	database.InitDB() // Wywołanie funkcji inicjalizującej bazę danych (tworzy plik i tabele)
	database.SeedData() // Wywołanie funkcji, która wczyta dane z listy, jeśli baza jest pusta

	e := echo.New() // Inicjalizacja nowej instancji frameworka Echo

	e.GET("/weather", controllers.GetWeather) // Przypisanie zaktualizowanego kontrolera do metody GET
	e.POST("/weather", controllers.GetWeather) // Przypisanie zaktualizowanego kontrolera do metody POST

	e.Logger.Fatal(e.Start(":8080")) // Uruchomienie serwera HTTP na porcie 8080
} // Zakończenie funkcji main
