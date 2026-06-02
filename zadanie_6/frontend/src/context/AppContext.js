import React, { createContext, useCallback, useMemo, useState } from 'react'; // Importujemy React oraz hooki potrzebne do stanu, callbacków i memoizacji danych kontekstu.
import PropTypes from 'prop-types'; // Importujemy walidację propsów wymaganą przez analizę statyczną komponentów React.
import apiClient from '../api/client'; // Importujemy wspólnego klienta axios do komunikacji z aplikacją serwerową.

export const AppContext = createContext(null); // Tworzymy kontekst, który będzie wspólnym źródłem danych dla Produktów, Koszyka i Płatności.

let nextCartItemId = 0; // Przechowujemy licznik pozycji koszyka używany do stabilnych kluczy Reacta.

const createCartItemId = (productId) => { // Tworzymy identyfikator pozycji koszyka unikalny w bieżącej sesji aplikacji.
  nextCartItemId += 1; // Zwiększamy licznik dopiero przy realnym dodaniu produktu do koszyka.
  return `${productId}-${nextCartItemId}`; // Łączymy identyfikator produktu z licznikiem pozycji.
}; // Kończymy funkcję createCartItemId.

const normalizeProduct = (product) => { // Normalizujemy dane z API, aby komponenty nie zakładały ślepo poprawnego typu odpowiedzi.
  const price = Number(product.price); // Zamieniamy cenę na liczbę, bo dane z serwera mogą przyjść jako tekst.

  if (!Number.isFinite(price)) { // Chronimy renderowanie przed wywołaniem toFixed na niepoprawnej wartości.
    throw new Error('Produkt z serwera ma niepoprawną cenę.');
  } // Kończymy walidację ceny.

  return { // Zwracamy bezpieczny obiekt produktu używany dalej w UI.
    id: product.id, // Zachowujemy identyfikator produktu z backendu.
    name: String(product.name ?? 'Produkt bez nazwy'), // Zapewniamy zawsze tekstową nazwę produktu.
    price, // Przekazujemy już zweryfikowaną cenę liczbową.
  }; // Kończymy normalizację produktu.
}; // Kończymy funkcję normalizeProduct.

export const AppProvider = ({ children }) => { // Definiujemy provider udostępniający stan aplikacji wszystkim widokom potomnym.
  const [products, setProducts] = useState([]); // Przechowujemy listę produktów pobraną z backendu.
  const [productsLoading, setProductsLoading] = useState(true); // Przechowujemy informację, czy trwa pobieranie produktów.
  const [productsError, setProductsError] = useState(''); // Przechowujemy komunikat błędu, gdy backend produktów nie odpowie poprawnie.
  const [cartItems, setCartItems] = useState([]); // Przechowujemy produkty dodane przez użytkownika do koszyka.

  const loadProducts = useCallback(async () => { // Definiujemy funkcję pobierającą produkty, którą uruchamia komponent Products.
    setProductsLoading(true); // Włączamy stan ładowania przed wysłaniem zapytania do backendu.
    setProductsError(''); // Czyścimy poprzedni błąd, aby nowa próba pobrania zaczynała się od czystego stanu.

    try { // Rozpoczynamy blok obsługi poprawnej odpowiedzi backendu.
      const response = await apiClient.get('/api/products'); // Pobieramy produkty z endpointu backendowego przy użyciu axios.
      if (!Array.isArray(response.data)) { // Sprawdzamy, czy backend zwrócił listę, a nie przypadkowy obiekt.
        throw new Error('Endpoint produktów nie zwrócił listy.');
      } // Kończymy walidację kształtu odpowiedzi.

      setProducts(response.data.map(normalizeProduct)); // Zapisujemy tylko znormalizowane produkty zwrócone przez aplikację serwerową.
    } catch (error) { // Obsługujemy realny błąd połączenia lub odpowiedzi serwera.
      console.error('Nie udało się pobrać produktów z serwera:', error); // Logujemy szczegóły błędu dla debugowania.
      setProducts([]); // Czyścimy produkty, aby nie udawać danych z serwera lokalnymi mockami.
      setProductsError('Nie udało się pobrać produktów z aplikacji serwerowej. Sprawdź, czy backend działa na porcie 8080.'); // Pokazujemy użytkownikowi jasny komunikat błędu.
    } finally { // Ten blok wykona się zarówno po sukcesie, jak i po błędzie.
      setProductsLoading(false); // Wyłączamy stan ładowania po zakończeniu próby pobierania.
    } // Kończymy blok finally.
  }, []); // Funkcja używa tylko stabilnych setterów Reacta, więc nie potrzebuje dodatkowych zależności.

  const addToCart = useCallback((product) => { // Definiujemy stabilną funkcję dodającą produkt do koszyka.
    const cartItem = { // Tworzymy pozycję koszyka przed aktualizacją stanu, aby updater Reacta pozostał czysty.
      ...product, // Przenosimy dane produktu do pozycji koszyka.
      cartItemId: createCartItemId(product.id), // Dodajemy stabilny identyfikator konkretnej pozycji w koszyku.
    }; // Kończymy budowanie pozycji koszyka.

    setCartItems((previousItems) => [ // Tworzymy nową tablicę, zachowując niezmienność stanu Reacta.
      ...previousItems, // Zachowujemy poprzednią zawartość koszyka.
      cartItem, // Dodajemy przygotowaną pozycję koszyka.
    ]); // Kończymy aktualizację koszyka.
  }, []); // Funkcja korzysta tylko ze stabilnego setCartItems, więc nie wymaga dodatkowych zależności.

  const removeFromCart = useCallback((cartItemIdToRemove) => { // Definiujemy stabilną funkcję usuwającą jeden wpis z koszyka po jego identyfikatorze.
    setCartItems((previousItems) => previousItems.filter((item) => item.cartItemId !== cartItemIdToRemove)); // Zostawiamy w koszyku wszystkie elementy poza klikniętym wpisem.
  }, []); // Funkcja korzysta tylko ze stabilnego setCartItems, więc pozostaje bez dodatkowych zależności.

  const clearCart = useCallback(() => { // Definiujemy stabilną funkcję czyszczącą koszyk po udanej płatności.
    setCartItems([]); // Ustawiamy koszyk na pustą tablicę.
  }, []); // Funkcja korzysta tylko ze stabilnego setCartItems, więc nie potrzebuje zależności.

  const cartTotal = cartItems.reduce((sum, item) => sum + item.price, 0); // Wyliczamy łączną wartość koszyka z cen zweryfikowanych produktów.

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
  }), [products, productsLoading, productsError, loadProducts, cartItems, cartTotal, addToCart, removeFromCart, clearCart]); // Odświeżamy obiekt tylko wtedy, gdy zmienią się jego dane lub funkcje.

  return ( // Zwracamy provider opakowujący całą aplikację.
    <AppContext.Provider value={contextValue}> {/* Przekazujemy przygotowane dane i funkcje do komponentów potomnych. */}
      {children} {/* Renderujemy widoki aplikacji mające dostęp do kontekstu. */}
    </AppContext.Provider>
  ); // Kończymy zwracanie JSX.
}; // Kończymy definicję AppProvider.

AppProvider.propTypes = { // Opisujemy propsy providera, aby Sonar nie zgłaszał braku walidacji children.
  children: PropTypes.node.isRequired,
}; // Kończymy walidację propsów AppProvider.
