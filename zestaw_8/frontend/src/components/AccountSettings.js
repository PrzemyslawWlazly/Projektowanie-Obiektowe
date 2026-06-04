import React, { useContext, useEffect, useState } from 'react'; // Importujemy React oraz hooki do formularza ustawień konta.
import { Link, useLocation } from 'react-router-dom'; // Importujemy Link i useLocation, aby wykryć spreparowane parametry URL w teście CSRF.
import { AppContext } from '../context/AppContext'; // Importujemy kontekst z sesją, ustawieniami i bezpieczną aktualizacją konta.

const AccountSettings = () => { // Definiujemy komponent ustawień konta wymagany do testów CSRF z punktu 4.5.
  const { currentUser, accountSettings, updateAccountSettings } = useContext(AppContext); // Pobieramy dane sesji oraz funkcję chronioną tokenem CSRF.
  const location = useLocation(); // Pobieramy aktualny adres, aby wykryć próbę przekazania zmian przez spreparowany link.
  const [displayName, setDisplayName] = useState(accountSettings.displayName); // Przechowujemy kontrolowaną nazwę wyświetlaną w formularzu.
  const [marketingConsent, setMarketingConsent] = useState(accountSettings.marketingConsent); // Przechowujemy kontrolowaną zgodę marketingową.
  const [statusMessage, setStatusMessage] = useState(''); // Przechowujemy komunikat po próbie zapisania ustawień.

  useEffect(() => { // Synchronizujemy pola formularza, gdy ustawienia zmienią się w innej karcie.
    setDisplayName(accountSettings.displayName); // Aktualizujemy nazwę wyświetlaną na podstawie stanu konta.
    setMarketingConsent(accountSettings.marketingConsent); // Aktualizujemy zgodę marketingową na podstawie stanu konta.
  }, [accountSettings]); // Efekt działa tylko po realnej zmianie ustawień.

  const hasSuspiciousQuery = location.search.length > 0; // Uznajemy dowolne parametry URL za podejrzane, bo ustawienia nie powinny zmieniać się linkiem GET.

  const handleSubmit = (event) => { // Tworzymy obsługę bezpiecznego zapisu ustawień konta.
    event.preventDefault(); // Blokujemy przeładowanie strony i klasyczną wysyłkę formularza.

    const form = event.currentTarget; // Pobieramy formularz, aby użyć jego ukrytego tokenu CSRF.
    const formData = new FormData(form); // Odczytujemy dane formularza w standardowy sposób.

    const result = updateAccountSettings({ // Próbujemy zapisać ustawienia przez funkcję kontrolującą token CSRF.
      displayName: formData.get('displayName'), // Przekazujemy nazwę wyświetlaną wpisaną przez użytkownika.
      marketingConsent: formData.get('marketingConsent') === 'on', // Checkbox zamieniamy na wartość boolowską.
    }, formData.get('csrfToken')); // Przekazujemy token z ukrytego pola formularza.

    setStatusMessage(result.message); // Pokazujemy wynik operacji użytkownikowi i testowi Selenium.
  }; // Kończymy obsługę zapisu ustawień.

  if (!currentUser) { // Sprawdzamy, czy użytkownik ma aktywną sesję.
    return ( // Zwracamy komunikat zamiast formularza, gdy użytkownik nie jest zalogowany.
      <section className="form-page" aria-labelledby="account-heading">
        <h2 id="account-heading">Ustawienia konta</h2>
        <p role="alert" data-testid="account-login-required">Musisz się zalogować, aby zmienić ustawienia konta.</p>
        <Link to="/login">Przejdź do logowania</Link>
      </section>
    ); // Kończymy widok niezalogowanego użytkownika.
  } // Kończymy warunek braku sesji.

  return ( // Zwracamy formularz ustawień konta dla zalogowanego użytkownika.
    <section className="form-page" aria-labelledby="account-heading"> {/* Sekcja zawiera chroniony formularz konta. */}
      <h2 id="account-heading">Ustawienia konta</h2> {/* Nagłówek identyfikuje widok ustawień. */}
      <p>Zalogowano jako <strong data-testid="account-user-email">{currentUser.email}</strong>.</p> {/* Pokazujemy właściciela aktywnej sesji. */}

      {hasSuspiciousQuery && ( // Jeżeli link zawiera parametry, pokazujemy informację o ich zignorowaniu.
        <p role="alert" data-testid="csrf-warning">Parametry z adresu URL zostały zignorowane. Ustawienia można zmienić tylko formularzem z tokenem CSRF.</p>
      )} {/* Kończymy komunikat ostrzegawczy dla spreparowanego linku. */}

      <form id="account-settings-form" className="account-form" onSubmit={handleSubmit}> {/* Formularz jest jedyną dozwoloną drogą zmiany ustawień. */}
        <input type="hidden" name="csrfToken" value={currentUser.csrfToken} data-testid="csrf-token" readOnly /> {/* Ukryty token wiąże zapis ustawień z aktywną sesją. */}

        <label htmlFor="account-display-name">Nazwa wyświetlana</label> {/* Etykieta opisuje ustawienie nazwy konta. */}
        <input // Rozpoczynamy pole nazwy wyświetlanej.
          id="account-display-name" // Id łączy input z etykietą i testem Selenium.
          name="displayName" // Nazwa pola używana przez FormData.
          type="text" // Typ tekstowy pozwala wpisać nazwę widoczną w profilu.
          value={displayName} // Pole jest kontrolowane przez stan Reacta.
          onChange={(event) => setDisplayName(event.target.value)} // Aktualizujemy stan po każdej zmianie pola.
          required // Nazwa wyświetlana nie może być pusta.
          data-testid="account-display-name" // Stabilny selektor testowy.
        /> {/* Zamykamy pole nazwy. */}

        <label className="checkbox-row" htmlFor="marketing-consent"> {/* Etykieta otacza checkbox i tekst ustawienia. */}
          <input // Rozpoczynamy checkbox zgody marketingowej.
            id="marketing-consent" // Id wiąże checkbox z etykietą.
            name="marketingConsent" // Nazwa pola używana przez FormData.
            type="checkbox" // Typ checkbox reprezentuje ustawienie boolowskie.
            checked={marketingConsent} // Checkbox jest kontrolowany przez stan Reacta.
            onChange={(event) => setMarketingConsent(event.target.checked)} // Aktualizujemy stan po kliknięciu.
            data-testid="marketing-consent" // Stabilny selektor testowy.
          /> {/* Zamykamy checkbox zgody. */}
          Zgoda na wiadomości promocyjne
        </label>

        <button type="submit" data-testid="account-save">Zapisz ustawienia</button> {/* Przycisk zapisuje ustawienia tylko z prawidłowym tokenem CSRF. */}
      </form> {/* Zamykamy formularz ustawień. */}

      <dl className="settings-summary" data-testid="account-settings-summary"> {/* Podsumowanie pokazuje aktualnie zapisany stan konta. */}
        <dt>Nazwa wyświetlana</dt>
        <dd data-testid="saved-display-name">{accountSettings.displayName}</dd>
        <dt>Zgoda marketingowa</dt>
        <dd data-testid="saved-marketing-consent">{accountSettings.marketingConsent ? 'tak' : 'nie'}</dd>
      </dl>

      {statusMessage && ( // Komunikat wyniku renderujemy po próbie zapisu.
        <p role="status" data-testid="account-status">{statusMessage}</p>
      )} {/* Kończymy warunkowy komunikat statusu. */}
    </section>
  ); // Kończymy zwracanie widoku ustawień konta.
}; // Kończymy komponent AccountSettings.

export default AccountSettings; // Eksportujemy widok ustawień do routingu aplikacji.
