import React, { createContext, useCallback, useEffect, useMemo, useState } from 'react'; // Importujemy React oraz hooki potrzebne do stanu, callbacków, efektów i memoizacji danych kontekstu.
import apiClient from '../api/client'; // Importujemy wspólnego klienta axios do komunikacji z aplikacją serwerową.

export const AppContext = createContext(null); // Tworzymy kontekst, który będzie wspólnym źródłem danych dla Produktów, Koszyka i Płatności.

const CART_STORAGE_KEY = 'magic-shop-cart-items'; // Definiujemy jeden klucz localStorage używany do synchronizacji koszyka między kartami przeglądarki.
const SESSION_STORAGE_KEY = 'magic-shop-session'; // Definiujemy klucz sesji użytkownika, aby druga karta widziała aktywne logowanie.
const ACCOUNT_SETTINGS_STORAGE_KEY = 'magic-shop-account-settings'; // Definiujemy klucz ustawień konta chronionych przed próbą CSRF.

const createCsrfToken = () => { // Tworzymy pomocniczy generator tokenu CSRF przypisanego do bieżącej sesji.
  if (typeof window !== 'undefined' && window.crypto && window.crypto.randomUUID) { // Sprawdzamy, czy przeglądarka udostępnia bezpieczny generator UUID.
    return window.crypto.randomUUID(); // Zwracamy losowy token, który formularz ustawień musi odesłać przy zmianie konta.
  } // Kończymy ścieżkę z crypto.randomUUID.

  return `csrf-${Date.now()}-${Math.random().toString(16).slice(2)}`; // Dajemy awaryjny token dla środowisk testowych bez randomUUID.
}; // Kończymy generator tokenu CSRF.

const readCartFromStorage = () => { // Tworzymy funkcję pomocniczą odczytującą koszyk zapisany wcześniej przez inną kartę.
  if (typeof window === 'undefined') { // Sprawdzamy, czy kod działa w przeglądarce, bo testy jednostkowe mogą nie mieć pełnego obiektu window.
    return []; // Poza przeglądarką zwracamy pusty koszyk, aby inicjalizacja stanu była bezpieczna.
  } // Kończymy zabezpieczenie środowiska.

  try { // Rozpoczynamy blok odporny na uszkodzony JSON w localStorage.
    const storedCart = window.localStorage.getItem(CART_STORAGE_KEY); // Pobieramy zapisany koszyk spod ustalonego klucza.

    if (!storedCart) { // Sprawdzamy, czy koszyk nie był jeszcze zapisany.
      return []; // Brak danych traktujemy jako pusty koszyk.
    } // Kończymy obsługę braku danych.

    const parsedCart = JSON.parse(storedCart); // Zamieniamy tekst JSON na strukturę JavaScript.
    return Array.isArray(parsedCart) ? parsedCart : []; // Akceptujemy tylko tablicę, aby nie wpuścić do stanu przypadkowych danych.
  } catch (error) { // Obsługujemy błędny JSON albo niedostępne localStorage.
    console.error('Nie udało się odczytać koszyka z localStorage:', error); // Logujemy problem dla debugowania testów wielokartowych.
    return []; // Przy błędzie wracamy do pustego koszyka zamiast psuć renderowanie aplikacji.
  } // Kończymy blok obsługi błędów.
}; // Kończymy funkcję odczytu koszyka.

const readSessionFromStorage = () => { // Tworzymy funkcję odczytującą aktywną sesję użytkownika z localStorage.
  if (typeof window === 'undefined') { // Zabezpieczamy inicjalizację na wypadek uruchomienia poza przeglądarką.
    return null; // Bez przeglądarki nie ma aktywnej sesji.
  } // Kończymy zabezpieczenie środowiska.

  try { // Rozpoczynamy odporny odczyt danych sesji.
    const storedSession = window.localStorage.getItem(SESSION_STORAGE_KEY); // Pobieramy zapis sesji spod ustalonego klucza.
    return storedSession ? JSON.parse(storedSession) : null; // Zwracamy obiekt sesji albo null, jeśli użytkownik nie jest zalogowany.
  } catch (error) { // Obsługujemy przypadek uszkodzonego JSON.
    console.error('Nie udało się odczytać sesji użytkownika:', error); // Logujemy problem dla debugowania testu CSRF.
    return null; // Uszkodzoną sesję traktujemy jak brak logowania.
  } // Kończymy blok obsługi błędów.
}; // Kończymy funkcję odczytu sesji.

const readAccountSettingsFromStorage = () => { // Tworzymy funkcję odczytującą ustawienia konta użytkownika.
  const defaultSettings = { displayName: 'Klient sklepu', marketingConsent: false }; // Ustalamy bezpieczne wartości domyślne przed pierwszą zmianą.

  if (typeof window === 'undefined') { // Sprawdzamy, czy działa przeglądarka z localStorage.
    return defaultSettings; // Poza przeglądarką zwracamy ustawienia domyślne.
  } // Kończymy zabezpieczenie środowiska.

  try { // Rozpoczynamy odporny odczyt ustawień.
    const storedSettings = window.localStorage.getItem(ACCOUNT_SETTINGS_STORAGE_KEY); // Pobieramy zapisane ustawienia konta.
    return storedSettings ? { ...defaultSettings, ...JSON.parse(storedSettings) } : defaultSettings; // Łączymy zapis z domyślnymi polami, aby brakujące wartości nie psuły UI.
  } catch (error) { // Obsługujemy uszkodzony JSON w localStorage.
    console.error('Nie udało się odczytać ustawień konta:', error); // Logujemy problem pomocny przy debugowaniu testów bezpieczeństwa.
    return defaultSettings; // Wracamy do bezpiecznych wartości domyślnych.
  } // Kończymy blok obsługi błędów.
}; // Kończymy funkcję odczytu ustawień.

export const AppProvider = ({ children }) => { // Definiujemy provider udostępniający stan aplikacji wszystkim widokom potomnym.
  const [products, setProducts] = useState([]); // Przechowujemy listę produktów pobraną z backendu.
  const [productsLoading, setProductsLoading] = useState(true); // Przechowujemy informację, czy trwa pobieranie produktów.
  const [productsError, setProductsError] = useState(''); // Przechowujemy komunikat błędu, gdy backend produktów nie odpowie poprawnie.
  const [cartItems, setCartItems] = useState(readCartFromStorage); // Przechowujemy produkty w koszyku, startując od danych wspólnych dla kart tej samej przeglądarki.
  const [currentUser, setCurrentUser] = useState(readSessionFromStorage); // Przechowujemy aktywnie zalogowanego użytkownika wraz z tokenem CSRF.
  const [accountSettings, setAccountSettings] = useState(readAccountSettingsFromStorage); // Przechowujemy ustawienia konta chronione przed nieautoryzowaną zmianą.

  useEffect(() => { // Synchronizujemy lokalny stan koszyka z trwałym zapisem po każdej zmianie pozycji.
    window.localStorage.setItem(CART_STORAGE_KEY, JSON.stringify(cartItems)); // Zapisujemy aktualny koszyk, aby nowa karta odczytała ten sam stan zamówienia.
  }, [cartItems]); // Efekt uruchamia się tylko wtedy, gdy użytkownik doda, usunie albo wyczyści pozycje koszyka.

  useEffect(() => { // Nasłuchujemy zmian localStorage wykonanych przez inne karty tej samej przeglądarki.
    const handleStorageChange = (event) => { // Definiujemy reakcję na zdarzenie storage wysyłane między kartami.
      if (event.key === CART_STORAGE_KEY) { // Sprawdzamy, czy inna karta zmieniła koszyk.
        setCartItems(readCartFromStorage()); // Odświeżamy stan w bieżącej karcie, aby widok koszyka był spójny z inną kartą.
      } // Kończymy obsługę zmiany koszyka.

      if (event.key === SESSION_STORAGE_KEY) { // Sprawdzamy, czy inna karta zalogowała lub wylogowała użytkownika.
        setCurrentUser(readSessionFromStorage()); // Synchronizujemy sesję, aby test CSRF działał przy kilku kartach.
      } // Kończymy obsługę zmiany sesji.

      if (event.key === ACCOUNT_SETTINGS_STORAGE_KEY) { // Sprawdzamy, czy ustawienia konta zmieniły się w innej karcie.
        setAccountSettings(readAccountSettingsFromStorage()); // Odświeżamy ustawienia w bieżącej karcie, żeby widok nie pokazywał starego stanu.
      } // Kończymy obsługę zmiany ustawień.
    }; // Kończymy funkcję obsługi zdarzenia.

    window.addEventListener('storage', handleStorageChange); // Rejestrujemy nasłuchiwanie zmian wykonywanych poza aktualną kartą.

    return () => { // Zwracamy funkcję sprzątającą uruchamianą przy odmontowaniu providera.
      window.removeEventListener('storage', handleStorageChange); // Usuwamy listener, aby nie zostawiać podwójnych subskrypcji po ponownym montowaniu.
    }; // Kończymy sprzątanie efektu.
  }, []); // Listener zakładamy raz, ponieważ korzysta ze stabilnych funkcji modułu i settera Reacta.

  const loadProducts = useCallback(async () => { // Definiujemy funkcję pobierającą produkty, którą uruchamia komponent Products.
    setProductsLoading(true); // Włączamy stan ładowania przed wysłaniem zapytania do backendu.
    setProductsError(''); // Czyścimy poprzedni błąd, aby nowa próba pobrania zaczynała się od czystego stanu.

    try { // Rozpoczynamy blok obsługi poprawnej odpowiedzi backendu.
      const response = await apiClient.get('/api/products'); // Pobieramy produkty z endpointu backendowego przy użyciu axios.
      setProducts(response.data); // Zapisujemy produkty zwrócone przez aplikację serwerową.
    } catch (error) { // Obsługujemy realny błąd połączenia lub odpowiedzi serwera.
      console.error('Nie udało się pobrać produktów z serwera:', error); // Logujemy szczegóły błędu dla debugowania.
      setProducts([]); // Czyścimy produkty, aby nie udawać danych z serwera lokalnymi mockami.
      setProductsError('Nie udało się pobrać produktów z aplikacji serwerowej. Sprawdź, czy backend działa na porcie 8080.'); // Pokazujemy użytkownikowi jasny komunikat błędu.
    } finally { // Ten blok wykona się zarówno po sukcesie, jak i po błędzie.
      setProductsLoading(false); // Wyłączamy stan ładowania po zakończeniu próby pobierania.
    } // Kończymy blok finally.
  }, []); // Funkcja używa tylko stabilnych setterów Reacta, więc nie potrzebuje dodatkowych zależności.

  const addToCart = useCallback((product) => { // Definiujemy stabilną funkcję dodającą produkt do koszyka.
    setCartItems((previousItems) => [...previousItems, product]); // Tworzymy nową tablicę, zachowując niezmienność stanu Reacta.
  }, []); // Funkcja korzysta tylko ze stabilnego setCartItems, więc nie wymaga dodatkowych zależności.

  const removeFromCart = useCallback((indexToRemove) => { // Definiujemy stabilną funkcję usuwającą jeden wpis z koszyka po jego indeksie.
    setCartItems((previousItems) => previousItems.filter((_, index) => index !== indexToRemove)); // Zostawiamy w koszyku wszystkie elementy poza klikniętym wpisem.
  }, []); // Funkcja korzysta tylko ze stabilnego setCartItems, więc pozostaje bez dodatkowych zależności.

  const clearCart = useCallback(() => { // Definiujemy stabilną funkcję czyszczącą koszyk po udanej płatności.
    setCartItems([]); // Ustawiamy koszyk na pustą tablicę.
  }, []); // Funkcja korzysta tylko ze stabilnego setCartItems, więc nie potrzebuje zależności.

  const login = useCallback((email, password) => { // Definiujemy logowanie potrzebne do testu CSRF na aktywnej sesji.
    if (!email || !password) { // Sprawdzamy, czy formularz przekazał wymagane dane.
      return false; // Brak danych oznacza nieudaną próbę logowania.
    } // Kończymy prostą walidację danych logowania.

    const session = { email, csrfToken: createCsrfToken() }; // Tworzymy sesję z tokenem CSRF wymaganym później przy zmianie ustawień.
    window.localStorage.setItem(SESSION_STORAGE_KEY, JSON.stringify(session)); // Zapisujemy sesję, aby była aktywna także w nowej karcie.
    setCurrentUser(session); // Aktualizujemy stan Reacta w bieżącej karcie.
    return true; // Zwracamy sukces, żeby formularz mógł pokazać właściwy komunikat.
  }, []); // Funkcja nie zależy od zmiennych komponentu, więc pozostaje stabilna.

  const logout = useCallback(() => { // Definiujemy wylogowanie użytkownika z bieżącej i pozostałych kart.
    window.localStorage.removeItem(SESSION_STORAGE_KEY); // Usuwamy sesję z localStorage.
    setCurrentUser(null); // Czyścimy zalogowanego użytkownika w stanie Reacta.
  }, []); // Funkcja korzysta tylko ze stabilnego setCurrentUser.

  const updateAccountSettings = useCallback((nextSettings, submittedCsrfToken) => { // Definiujemy bezpieczną zmianę ustawień konta.
    if (!currentUser) { // Sprawdzamy, czy użytkownik ma aktywną sesję.
      return { success: false, message: 'Musisz być zalogowany, aby zmienić ustawienia konta.' }; // Bez sesji zmiana ustawień jest odrzucona.
    } // Kończymy kontrolę sesji.

    if (submittedCsrfToken !== currentUser.csrfToken) { // Porównujemy token formularza z tokenem zapisanym w aktywnej sesji.
      return { success: false, message: 'Odrzucono zmianę ustawień, ponieważ token CSRF jest niepoprawny.' }; // Niepoprawny token blokuje próbę wymuszenia zmiany.
    } // Kończymy kontrolę tokenu CSRF.

    const safeSettings = { // Budujemy nowy stan ustawień wyłącznie z pól obsługiwanych przez formularz.
      displayName: nextSettings.displayName, // Przenosimy nazwę wyświetlaną podaną przez użytkownika.
      marketingConsent: Boolean(nextSettings.marketingConsent), // Normalizujemy zgodę marketingową do wartości boolowskiej.
    }; // Kończymy budowę bezpiecznych ustawień.

    window.localStorage.setItem(ACCOUNT_SETTINGS_STORAGE_KEY, JSON.stringify(safeSettings)); // Zapisujemy zaakceptowane ustawienia do localStorage.
    setAccountSettings(safeSettings); // Aktualizujemy bieżący widok konta.
    return { success: true, message: 'Ustawienia konta zostały zapisane.' }; // Zwracamy komunikat sukcesu dla formularza.
  }, [currentUser]); // Funkcja zależy od aktualnego użytkownika i jego tokenu CSRF.

  const cartTotal = cartItems.reduce((sum, item) => sum + item.price, 0); // Wyliczamy łączną wartość koszyka z cen produktów.

  const contextValue = useMemo(() => ({ // Memoizujemy obiekt kontekstu, aby ograniczyć niepotrzebne renderowania konsumentów.
    products, // Udostępniamy listę produktów komponentowi Produkty.
    productsLoading, // Udostępniamy informację o ładowaniu produktów.
    productsError, // Udostępniamy błąd pobierania produktów.
    loadProducts, // Udostępniamy funkcję pobierania produktów komponentowi Products.
    cartItems, // Udostępniamy zawartość koszyka komponentowi Koszyk.
    cartTotal, // Udostępniamy sumę koszyka komponentom Koszyk i Płatności.
    addToCart, // Udostępniamy funkcję dodawania produktu do koszyka.
    removeFromCart, // Udostępniamy funkcję usuwania produktu z koszyka.
    clearCart, // Udostępniamy funkcję czyszczenia koszyka po poprawnej płatności.
    currentUser, // Udostępniamy aktywną sesję formularzowi logowania i ustawieniom konta.
    accountSettings, // Udostępniamy ustawienia konta widokowi chronionemu przed CSRF.
    login, // Udostępniamy funkcję logowania.
    logout, // Udostępniamy funkcję wylogowania.
    updateAccountSettings, // Udostępniamy bezpieczną zmianę ustawień wymagającą tokenu CSRF.
  }), [products, productsLoading, productsError, loadProducts, cartItems, cartTotal, addToCart, removeFromCart, clearCart, currentUser, accountSettings, login, logout, updateAccountSettings]); // Odświeżamy obiekt tylko wtedy, gdy zmienią się jego dane lub funkcje.

  return ( // Zwracamy provider opakowujący całą aplikację.
    <AppContext.Provider value={contextValue}> {/* Przekazujemy przygotowane dane i funkcje do komponentów potomnych. */}
      {children} {/* Renderujemy widoki aplikacji mające dostęp do kontekstu. */}
    </AppContext.Provider>
  ); // Kończymy zwracanie JSX.
}; // Kończymy definicję AppProvider.
