import React, { useContext, useState } from 'react'; // Importujemy React, useContext i useState do obsługi formularza logowania.
import { Link } from 'react-router-dom'; // Importujemy Link, aby po zalogowaniu można było przejść do ustawień konta bez przeładowania strony.
import { AppContext } from '../context/AppContext'; // Importujemy wspólny kontekst zawierający funkcję logowania i aktywną sesję.

const Login = () => { // Definiujemy komponent formularza logowania wymagany dla punktu 4.5.
  const { currentUser, login, logout } = useContext(AppContext); // Pobieramy stan sesji oraz akcje logowania i wylogowania.
  const [statusMessage, setStatusMessage] = useState(''); // Przechowujemy komunikat po próbie logowania lub wylogowania.

  const handleSubmit = (event) => { // Tworzymy obsługę wysłania formularza logowania.
    event.preventDefault(); // Blokujemy przeładowanie strony, żeby aplikacja React zachowała kontrolę nad sesją.

    const form = event.currentTarget; // Pobieramy formularz, aby użyć natywnej walidacji HTML5.

    if (!form.checkValidity()) { // Sprawdzamy, czy e-mail i hasło spełniają wymagania pól.
      setStatusMessage(''); // Czyścimy komunikat, bo niepoprawny formularz nie jest próbą udanego logowania.
      form.reportValidity(); // Prosimy przeglądarkę o pokazanie standardowego błędu walidacji.
      return; // Przerywamy obsługę błędnych danych.
    } // Kończymy walidację formularza.

    const formData = new FormData(form); // Odczytujemy dane formularza przez standardowe API.
    const email = formData.get('email'); // Pobieramy adres e-mail użytkownika.
    const password = formData.get('password'); // Pobieramy hasło użytkownika.

    if (login(email, password)) { // Wywołujemy logowanie i sprawdzamy, czy sesja została utworzona.
      setStatusMessage('Użytkownik został zalogowany.'); // Informujemy użytkownika o aktywnej sesji.
      form.reset(); // Czyścimy pola formularza po udanym logowaniu.
    } else { // Obsługujemy nieudaną próbę logowania.
      setStatusMessage('Nie udało się zalogować użytkownika.'); // Pokazujemy neutralny komunikat błędu.
    } // Kończymy obsługę wyniku logowania.
  }; // Kończymy funkcję wysłania formularza.

  const handleLogout = () => { // Definiujemy obsługę wylogowania z aktywnej sesji.
    logout(); // Czyścimy sesję w kontekście i localStorage.
    setStatusMessage('Użytkownik został wylogowany.'); // Pokazujemy komunikat potwierdzający wylogowanie.
  }; // Kończymy obsługę wylogowania.

  return ( // Zwracamy widok logowania.
    <section className="form-page" aria-labelledby="login-heading"> {/* Sekcja opisuje samodzielny widok konta. */}
      <h2 id="login-heading">Logowanie</h2> {/* Nagłówek jednoznacznie identyfikuje formularz logowania. */}

      {currentUser ? ( // Sprawdzamy, czy użytkownik jest już zalogowany.
        <div data-testid="login-session"> {/* Kontener sesji pozwala Selenium potwierdzić aktywne logowanie. */}
          <p>Zalogowano jako <strong data-testid="logged-user-email">{currentUser.email}</strong>.</p> {/* Pokazujemy e-mail aktywnej sesji. */}
          <button type="button" data-testid="logout-button" onClick={handleLogout}>Wyloguj</button> {/* Pozwalamy zakończyć sesję użytkownika. */}
          <p><Link to="/account">Przejdź do ustawień konta</Link></p> {/* Link prowadzi do chronionego formularza ustawień. */}
        </div>
      ) : ( // Jeżeli sesji nie ma, pokazujemy formularz logowania.
        <form id="login-form" className="account-form" onSubmit={handleSubmit}> {/* Formularz tworzy aktywną sesję wymaganą w teście CSRF. */}
          <label htmlFor="login-email">Adres e-mail</label> {/* Etykieta opisuje pole loginu. */}
          <input // Rozpoczynamy pole e-mail użytkownika.
            id="login-email" // Id łączy input z etykietą i stabilizuje test Selenium.
            name="email" // Nazwa pola pozwala odczytać wartość przez FormData.
            type="email" // Typ email wymusza poprawny format adresu.
            required // Logowanie wymaga podania adresu e-mail.
            data-testid="login-email" // Selektor testowy używany przez Selenium.
          /> {/* Zamykamy pole e-mail. */}

          <label htmlFor="login-password">Hasło</label> {/* Etykieta opisuje pole hasła. */}
          <input // Rozpoczynamy pole hasła.
            id="login-password" // Id łączy pole z etykietą i testami.
            name="password" // Nazwa pola pozwala odczytać hasło przez FormData.
            type="password" // Typ password ukrywa wpisane znaki.
            required // Hasło jest wymagane do utworzenia sesji.
            data-testid="login-password" // Selektor testowy używany przez Selenium.
          /> {/* Zamykamy pole hasła. */}

          <button type="submit" data-testid="login-submit">Zaloguj</button> {/* Przycisk tworzy sesję i token CSRF. */}
        </form>
      )} {/* Kończymy warunkowe renderowanie sesji albo formularza. */}

      {statusMessage && ( // Komunikat pokazujemy tylko po akcji użytkownika.
        <p role="status" data-testid="login-status">{statusMessage}</p>
      )} {/* Kończymy warunkowe renderowanie statusu. */}
    </section>
  ); // Kończymy zwracanie JSX.
}; // Kończymy komponent Login.

export default Login; // Eksportujemy widok logowania do routingu aplikacji.
