<?php // Rozpoczęcie skryptu PHP

namespace App\Controller; // Definiujemy przestrzeń nazw, w której znajduje się ten plik (standard ułożenia plików w Symfony)

use App\Entity\Product; // Importujemy nasz model (encję) Produktu, aby móc z niego korzystać w kodzie
use Doctrine\ORM\EntityManagerInterface; // Importujemy główne narzędzie Doctrine do komunikacji i operacji na bazie danych
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController; // Importujemy klasę bazową kontrolera Symfony, z której nasz kontroler dziedziczy funkcje
use Symfony\Component\HttpFoundation\JsonResponse; // Importujemy klasę odpowiedzialną za zwracanie poprawnej odpowiedzi HTTP w formacie JSON
use Symfony\Component\HttpFoundation\Request; // Importujemy klasę obsługującą dane przychodzące od użytkownika (np. cokolwiek wyślemy przez cURL)
use Symfony\Component\Routing\Annotation\Route; // Importujemy atrybut Route do definiowania adresów URL (endpointów) dla naszych metod

#[Route('/api/products', name: 'api_product_')] // Ustawiamy globalny prefix adresu URL i początek nazwy dla wszystkich metod w tej klasie
class ApiProductController extends AbstractController // Deklarujemy klasę naszego kontrolera, rozszerzającą funkcjonalności AbstractController
{
    // 1. READ ALL (Pobieranie wszystkich produktów)
    #[Route('', name: 'index', methods: ['GET'])] // Definiujemy pustą końcówkę adresu (więc URL to nadal '/api/products') obsługującą tylko żądanie typu GET
    public function index(EntityManagerInterface $entityManager): JsonResponse // Tworzymy funkcję wstrzykującą menedżera bazy danych, zmuszając ją do zwrócenia typu JsonResponse
    {
        $products = $entityManager->getRepository(Product::class)->findAll(); // Pobieramy z bazy danych absolutnie wszystkie rekordy przypisane do modelu Product
        $data = []; // Inicjujemy pustą tablicę, w której przygotujemy dane do wysłania

        foreach ($products as $product) { // Otwieramy pętlę, która przejdzie pokolei przez każdy pobrany z bazy obiekt produktu
            $data[] = [ // Dodajemy nowy element (tablicę asocjacyjną) na koniec naszej listy $data
                'id' => $product->getId(), // Wyciągamy ID z obiektu produktu i przypisujemy do klucza 'id'
                'name' => $product->getName(), // Wyciągamy nazwę z obiektu produktu i przypisujemy do klucza 'name'
                'price' => $product->getPrice(), // Wyciągamy cenę z obiektu produktu i przypisujemy do klucza 'price'
            ]; // Zamykamy definicję danych dla pojedynczego produktu w pętli
        } // Zamykamy pętlę foreach

        return $this->json($data); // Przekształcamy naszą uzupełnioną tablicę PHP w ciąg znaków JSON i zwracamy do przeglądarki/curla
    } // Zamykamy metodę index

    // 2. READ ONE (Pobieranie jednego produktu po ID)
    #[Route('/{id}', name: 'show', methods: ['GET'])] // Definiujemy adres z dynamicznym parametrem '{id}' (np. /api/products/5), obsługujący metodę GET
    public function show(EntityManagerInterface $entityManager, int $id): JsonResponse // Funkcja przyjmuje menedżera bazy oraz przechwytuje ID z adresu URL jako liczbę całkowitą
    {
        $product = $entityManager->getRepository(Product::class)->find($id); // Szukamy w bazie danych dokładnie jednego produktu, którego ID pasuje do tego z URL

        if (!$product) { // Sprawdzamy instrukcją warunkową, czy wynik poszukiwań okazał się pusty (produkt nie istnieje)
            return $this->json(['message' => 'Nie znaleziono produktu'], 404); // Przerywamy funkcję i zwracamy błąd JSON z kodem HTTP 404 (Not Found)
        } // Zamykamy instrukcję warunkową

        return $this->json([ // Konstruujemy nową odpowiedź JSON, ponieważ produkt został znaleziony
            'id' => $product->getId(), // Wyciągamy z niego ID
            'name' => $product->getName(), // Wyciągamy z niego nazwę
            'price' => $product->getPrice(), // Wyciągamy z niego cenę
        ]); // Zamykamy definicję tablicy i metody zwracającej JSON
    } // Zamykamy metodę show

    // 3. CREATE (Dodawanie nowego produktu)
    #[Route('', name: 'create', methods: ['POST'])] // Adres bazowy '/api/products' akceptujący tylko żądania typu POST (tworzenie nowych zasobów)
    public function create(Request $request, EntityManagerInterface $entityManager): JsonResponse // Wstrzykujemy Request (aby dobrać się do danych wysłanych przez klienta) i menedżer bazy
    {
        // Odbieramy dane w formacie JSON z żądania
        $data = json_decode($request->getContent(), true); // Wyciągamy surowy tekst (JSON) przesłany przez klienta i dekodujemy go na tablicę asocjacyjną PHP

        if (empty($data['name']) || empty($data['price'])) { // Sprawdzamy, czy w przesłanych danych brakuje klucza nazwy LUB ceny (pola obowiązkowe)
            return $this->json(['message' => 'Brakujące dane (name, price)'], 400); // Przerywamy działanie zwracając błąd z kodem 400 (Bad Request)
        } // Zamykamy warunek sprawdzający poprawność przesyłu

        $product = new Product(); // Tworzymy nową, pustą w pamięci instancję obiektu naszego modelu Product
        $product->setName($data['name']); // Ustawiamy nazwę tego nowego obiektu na wartość przekazaną przez użytkownika
        $product->setPrice((float) $data['price']); // Ustawiamy cenę, rzutując ją twardo na typ zmiennoprzecinkowy (float), by zapobiec błędom

        // Zapisujemy do bazy
        $entityManager->persist($product); // Mówimy Doctrine: "obserwuj ten nowy obiekt, przygotuj go do wrzucenia do bazy"
        $entityManager->flush(); // Mówimy Doctrine: "wykonaj fizycznie zapytanie INSERT do pliku bazy danych, zapisz zmiany"

        return $this->json(['message' => 'Produkt dodany', 'id' => $product->getId()], 201); // Zwracamy komunikat sukcesu z nowym ID produktu oraz kodem 201 (Created)
    } // Zamykamy metodę create

    // 4. UPDATE (Edycja istniejącego produktu)
    #[Route('/{id}', name: 'update', methods: ['PUT', 'PATCH'])] // Adres URL z identyfikatorem produktu, akceptujący żądania edycji PUT (całość) lub PATCH (częściowo)
    public function update(Request $request, EntityManagerInterface $entityManager, int $id): JsonResponse // Wstrzykujemy Request z danymi, menedżera bazy i ID z adresu URL
    {
        $product = $entityManager->getRepository(Product::class)->find($id); // Szukamy w bazie produktu, który klient chce edytować

        if (!$product) { // Jeśli taki produkt w bazie nie figuruje
            return $this->json(['message' => 'Nie znaleziono produktu'], 404); // Zwracamy standardowy błąd braku zasobu (404)
        } // Zamykamy warunek

        $data = json_decode($request->getContent(), true); // Podobnie jak przy tworzeniu, zamieniamy przesłanego JSON-a na tablicę w PHP

        if (!empty($data['name'])) { // Sprawdzamy, czy klient w ogóle przesłał nową nazwę w paczce danych
            $product->setName($data['name']); // Jeśli tak, nadpisujemy starą nazwę w obiekcie na nową
        } // Zamykamy warunek dla nazwy
        
        if (!empty($data['price'])) { // Sprawdzamy, czy klient przesłał nową cenę
            $product->setPrice((float) $data['price']); // Jeśli tak, nadpisujemy cenę (po upewnieniu się, że to float)
        } // Zamykamy warunek dla ceny

        $entityManager->flush(); // Fizycznie wykonujemy zapytanie UPDATE na bazie danych z naniesionymi zmianami

        return $this->json(['message' => 'Produkt zaktualizowany']); // Zwracamy informację o sukcesie edycji (kod to domyślne 200 OK)
    } // Zamykamy metodę update

    // 5. DELETE (Usuwanie produktu)
    #[Route('/{id}', name: 'delete', methods: ['DELETE'])] // Adres URL z identyfikatorem, akceptujący wyłącznie żądanie kasowania (DELETE)
    public function delete(EntityManagerInterface $entityManager, int $id): JsonResponse // Wstrzykujemy menedżera oraz numer ID do usunięcia
    {
        $product = $entityManager->getRepository(Product::class)->find($id); // Próbujemy zlokalizować w bazie konkretny produkt po tym identyfikatorze

        if (!$product) { // Jeśli wyszukiwanie zwróci null (produkt nie istnieje)
            return $this->json(['message' => 'Nie znaleziono produktu'], 404); // Odpowiadamy błędem i przerywamy proces
        } // Zamykamy warunek sprawdzający

        $entityManager->remove($product); // Mówimy Doctrine: "oznacz ten obiekt jako przeznaczony do skasowania z bazy"
        $entityManager->flush(); // Fizycznie wykonujemy operację DELETE na tabeli bazy danych

        return $this->json(['message' => 'Produkt usunięty']); // Odpowiadamy klientowi komunikatem potwierdzającym skasowanie danych
    } // Zamykamy metodę delete
} // Zamykamy całą klasę kontrolera
