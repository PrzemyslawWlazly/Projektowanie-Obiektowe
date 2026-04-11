package models // Deklaracja pakietu models, w którym trzymamy struktury danych

import "gorm.io/gorm" // Import biblioteki GORM do mapowania obiektowo-relacyjnego (ORM)

type Weather struct { // Definicja struktury Weather reprezentującej tabelę w bazie
	gorm.Model // Wbudowany typ GORM dodający kolumny: ID, CreatedAt, UpdatedAt, DeletedAt
	City        string  `json:"city"` // Pole City przechowujące nazwę miasta; tag json ustala nazwę klucza w odpowiedzi
	Temperature float64 `json:"temperature"` // Pole Temperature przechowujące temperaturę jako liczbę zmiennoprzecinkową
	Description string  `json:"description"` // Pole Description przechowujące tekstowy opis pogody
} // Zakończenie definicji struktury Weather
