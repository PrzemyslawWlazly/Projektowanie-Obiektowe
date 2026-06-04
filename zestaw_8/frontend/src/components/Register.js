import React, { useState } from 'react'; // Importujemy React oraz useState, ponieważ formularz ma własny komunikat po poprawnej rejestracji.

const Register = () => { // Definiujemy komponent formularza rejestracji użytkownika testowany przez Selenium dla wymagania 3.0.
  const [successMessage, setSuccessMessage] = useState(''); // Przechowujemy komunikat sukcesu widoczny dopiero po przejściu walidacji formularza.
  const [registeredUser, setRegisteredUser] = useState(null); // Przechowujemy ostatnie poprawne dane, aby test XSS mógł sprawdzić bezpieczne renderowanie tekstu.

  const handleSubmit = (event) => { // Tworzymy obsługę wysłania formularza uruchamianą po kliknięciu przycisku "Zarejestruj".
    event.preventDefault(); // Blokujemy przeładowanie strony, aby test Selenium mógł sprawdzić zachowanie aplikacji po walidacji.

    const form = event.currentTarget; // Pobieramy aktualny formularz, dzięki czemu korzystamy z natywnego API walidacji HTML5.

    if (!form.checkValidity()) { // Sprawdzamy, czy przeglądarka uznała wymagane pola i format e-maila za poprawne.
      setSuccessMessage(''); // Czyścimy komunikat sukcesu, aby błędny formularz nie wyglądał jak zaakceptowany.
      setRegisteredUser(null); // Czyścimy podgląd danych, ponieważ błędny formularz nie powinien prezentować żadnej rejestracji.
      form.reportValidity(); // Prosimy przeglądarkę o pokazanie standardowego komunikatu walidacyjnego przy niepoprawnym polu.
      return; // Przerywamy obsługę, bo niepoprawne dane nie powinny uruchamiać rejestracji.
    } // Kończymy gałąź walidacji negatywnej.

    const formData = new FormData(form); // Pobieramy dane formularza przez standardowe API, bez ręcznego czytania każdego pola osobno.
    setRegisteredUser({ // Zapisujemy dane do kontrolowanego podglądu renderowanego później przez Reacta.
      name: formData.get('name'), // Zachowujemy nazwę użytkownika, nawet jeśli test wpisze payload XSS.
      email: formData.get('email'), // Zachowujemy adres e-mail potrzebny do podglądu poprawnie przyjętych danych.
    }); // Kończymy zapis danych rejestracji.
    setSuccessMessage('Konto testowe zostało poprawnie przygotowane do rejestracji.'); // Pokazujemy kontrolowany komunikat po poprawnych danych.
  }; // Kończymy funkcję obsługującą wysyłkę formularza.

  return ( // Zwracamy widok rejestracji jako osobną podstronę aplikacji React.
    <section className="form-page" aria-labelledby="register-heading"> {/* Opakowujemy formularz w sekcję z etykietą dostępności. */}
      <h2 id="register-heading">Rejestracja użytkownika</h2> {/* Nagłówek pozwala użytkownikowi i testom łatwo rozpoznać widok. */}

      <form id="registration-form" className="account-form" onSubmit={handleSubmit} noValidate={false}> {/* Formularz używa natywnej walidacji HTML5 wymaganej w testach Selenium. */}
        <label htmlFor="register-name">Imię i nazwisko</label> {/* Etykieta opisuje obowiązkowe pole tekstowe z nazwą użytkownika. */}
        <input // Rozpoczynamy kontrolowane przez przeglądarkę pole imienia i nazwiska.
          id="register-name" // Id łączy input z etykietą oraz ułatwia stabilne wyszukanie elementu w Selenium.
          name="name" // Nazwa pola reprezentuje dane wysyłane podczas klasycznej rejestracji.
          type="text" // Typ tekstowy pozwala wpisać imię, nazwisko albo nazwę użytkownika.
          placeholder="Hermiona Granger" // Przykład wartości pomaga ręcznie sprawdzić formularz.
          required // Pole jest obowiązkowe, więc puste wysłanie formularza powinno zostać zablokowane.
          data-testid="registration-name" // Atrybut testowy daje Selenium odporny selektor niezależny od stylów.
        /> {/* Zamykamy pole imienia i nazwiska. */}

        <label htmlFor="register-email">Adres e-mail</label> {/* Etykieta opisuje pole sprawdzające format adresu e-mail. */}
        <input // Rozpoczynamy pole e-mail walidowane przez przeglądarkę.
          id="register-email" // Id łączy input z etykietą i jest używane w testach automatycznych.
          name="email" // Nazwa pola odpowiada typowym danym formularza rejestracji.
          type="email" // Typ email wymusza poprawny format, np. obecność znaku @ i części domenowej.
          placeholder="uzytkownik@example.com" // Podajemy neutralny przykład poprawnego adresu.
          required // Pole e-mail jest obowiązkowe, dlatego pusty formularz ma nie przejść walidacji.
          data-testid="registration-email" // Stabilny selektor testowy pozwala sprawdzić błędny format adresu.
        /> {/* Zamykamy pole e-mail. */}

        <label htmlFor="register-password">Hasło</label> {/* Etykieta opisuje obowiązkowe pole hasła. */}
        <input // Rozpoczynamy pole hasła dla konta użytkownika.
          id="register-password" // Id łączy input hasła z etykietą oraz testami.
          name="password" // Nazwa pola odpowiada danym rejestracji.
          type="password" // Typ password ukrywa wpisywane znaki w interfejsie.
          minLength="8" // Wymagamy co najmniej 8 znaków, aby formularz miał podstawową walidację jakości hasła.
          required // Hasło jest polem obowiązkowym i puste wysłanie powinno zostać zablokowane.
          data-testid="registration-password" // Stabilny selektor testowy dla walidacji pola hasła.
        /> {/* Zamykamy pole hasła. */}

        <button type="submit" data-testid="registration-submit">Zarejestruj</button> {/* Przycisk uruchamia walidację i ewentualną obsługę poprawnego formularza. */}
      </form> {/* Zamykamy formularz rejestracji. */}

      {successMessage && ( // Komunikat renderujemy tylko wtedy, gdy użytkownik poda poprawne dane.
        <p role="status" data-testid="registration-success"> {/* Rola status pozwala asystentom dostępności i testom wykryć wynik akcji. */}
          {successMessage} {/* Wyświetlamy tekst sukcesu po przejściu walidacji HTML5. */}
        </p>
      )} {/* Kończymy warunkowe renderowanie komunikatu sukcesu. */}

      {registeredUser && ( // Podgląd pokazujemy tylko dla danych, które przeszły walidację formularza.
        <div data-testid="registration-preview"> {/* Kontener podglądu daje Selenium miejsce do testowania odporności Reacta na XSS. */}
          <h3>Podgląd rejestracji</h3> {/* Nagłówek oddziela dane użytkownika od formularza. */}
          <p>Użytkownik: <span data-testid="registration-preview-name">{registeredUser.name}</span></p> {/* React renderuje nazwę jako tekst, więc payload HTML nie powinien stać się elementem DOM. */}
          <p>E-mail: <span data-testid="registration-preview-email">{registeredUser.email}</span></p> {/* Adres e-mail także renderujemy jako tekst bez użycia niebezpiecznego HTML. */}
        </div>
      )} {/* Kończymy warunkowy podgląd rejestracji. */}
    </section>
  ); // Kończymy zwracanie JSX formularza.
}; // Kończymy definicję komponentu Register.

export default Register; // Eksportujemy formularz, aby App.js mógł podłączyć go jako trasę /register.
