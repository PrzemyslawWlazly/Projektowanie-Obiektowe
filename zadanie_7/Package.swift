// swift-tools-version:5.9
// Powyzej okreslamy minimalna wersje narzedzi Swift Package Manager potrzebna do zbudowania projektu.

import PackageDescription // Importujemy opis pakietu, aby moc zdefiniowac zaleznosci i targety aplikacji.

let package = Package( // Tworzymy glowny opis pakietu Swift.
    name: "zadanie_7", // Ustawiamy nazwe projektu zgodna z katalogiem zadania.
    platforms: [ // Okreslamy systemy, na ktorych aplikacja moze byc uruchamiana.
        .macOS(.v13) // Vapor 4 dobrze wspolpracuje z nowoczesnymi wersjami macOS.
    ],
    dependencies: [ // W tej sekcji wpisujemy zewnetrzne biblioteki uzywane przez projekt.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"), // Vapor odpowiada za serwer HTTP i routing.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"), // Fluent jest ORM-em, czyli mapuje modele Swift na rekordy w bazie.
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0"), // Sterownik SQLite pozwala uzyc lokalnej bazy danych.
        .package(url: "https://github.com/vapor/leaf.git", from: "4.0.0"), // Leaf pozwala renderowac strony HTML z szablonow.
        .package(url: "https://github.com/vapor/redis.git", from: "4.0.0") // Redis pozwala przechowywac dane w pamieciowym magazynie klucz-wartosc.
    ],
    targets: [ // Targety mowia Swiftowi, jakie moduly ma budowac.
        .executableTarget( // Definiujemy target wykonywalny, czyli aplikacje uruchamiana z terminala.
            name: "App", // Nazwa targetu odpowiada katalogowi Sources/App.
            dependencies: [ // Tutaj przypinamy biblioteki potrzebne aplikacji.
                .product(name: "Vapor", package: "vapor"), // Dodajemy framework Vapor.
                .product(name: "Fluent", package: "fluent"), // Dodajemy ORM Fluent.
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"), // Dodajemy sterownik SQLite dla Fluent.
                .product(name: "Leaf", package: "leaf"), // Dodajemy silnik szablonow Leaf.
                .product(name: "Redis", package: "redis") // Dodajemy integracje Vapora z Redis.
            ]
        )
    ]
)
