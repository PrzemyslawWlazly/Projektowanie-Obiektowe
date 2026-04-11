package database // Deklaracja pakietu database obsługującego bazę danych

import ( // Rozpoczęcie bloku importów
	"log" // Import biblioteki do logowania informacji i błędów w konsoli
	"gorm.io/driver/sqlite" // Import sterownika bazy SQLite dla biblioteki GORM
	"gorm.io/gorm" // Import głównej biblioteki GORM
	"zestaw_4/models" // Import naszego lokalnego pakietu models
) // Zakończenie bloku importów

var DB *gorm.DB // Globalna zmienna DB przechowująca wskaźnik do połączenia z bazą danych

func InitDB() { // Funkcja inicjalizująca połączenie z bazą danych
	var err error // Deklaracja zmiennej do przechwytywania ewentualnych błędów
	DB, err = gorm.Open(sqlite.Open("weather.db"), &gorm.Config{}) // Otwarcie połączenia z plikiem SQLite "weather.db"
	if err != nil { // Sprawdzenie, czy podczas łączenia wystąpił błąd
		log.Fatal("Nie udało się połączyć z bazą danych") // Logowanie błędu krytycznego i zatrzymanie aplikacji
	} // Zakończenie bloku warunkowego

	DB.AutoMigrate(&models.Weather{}) // Automatyczne utworzenie/aktualizacja tabeli na podstawie struktury Weather
} // Zakończenie funkcji InitDB

func SeedData() { // Funkcja ładująca początkowe dane z listy przy uruchomieniu (wymóg z zadania 3.5)
	var count int64 // Zmienna do przechowania liczby rekordów w tabeli
	DB.Model(&models.Weather{}).Count(&count) // Zapytanie do bazy zliczające obecne rekordy w tabeli Weather
	
	if count == 0 { // Jeśli tabela jest pusta (count wynosi 0), dodajemy dane
		weathers := []models.Weather{ // Stworzenie listy (slice) z początkowymi danymi
			{City: "Warszawa", Temperature: 15.5, Description: "Pochmurno"}, // Pierwszy obiekt na liście
			{City: "Kraków", Temperature: 18.0, Description: "Słonecznie"}, // Drugi obiekt na liście
			{City: "Gdańsk", Temperature: 12.0, Description: "Wietrznie"}, // Trzeci obiekt na liście
		} // Zakończenie tworzenia listy
		
		DB.Create(&weathers) // Wrzucenie całej listy obiektów do bazy danych za pomocą GORM
		log.Println("Baza danych została zasilona początkowymi danymi.") // Wypisanie informacji w konsoli
	} // Zakończenie bloku warunkowego
} // Zakończenie funkcji SeedData
