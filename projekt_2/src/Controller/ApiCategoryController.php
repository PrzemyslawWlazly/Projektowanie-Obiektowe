<?php // Rozpoczęcie pliku ze skryptem PHP

namespace App\Controller; // Definiujemy ścieżkę (przestrzeń nazw), w jakiej znajduje się nasz kontroler

use App\Entity\Category; // Importujemy model Category (Kategorię), aby framework wiedział, na czym pracujemy
use Doctrine\ORM\EntityManagerInterface; // Importujemy menedżera bazy danych do zapisywania i pobierania informacji
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController; // Importujemy klasę bazową Symfony, z której dziedziczymy przydatne funkcje
use Symfony\Component\HttpFoundation\JsonResponse; // Importujemy klasę, która odpowiada za poprawne zwracanie formatu JSON do przeglądarki/curla
use Symfony\Component\HttpFoundation\Request; // Importujemy klasę obsługującą dane przychodzące w żądaniu HTTP (np. z formularza lub curla)
use Symfony\Component\Routing\Annotation\Route; // Importujemy narzędzie do tworzenia adresów URL dla naszych funkcji

#[Route('/api/categories', name: 'api_category_')] // Ustawiamy główny przedrostek adresu URL dla wszystkich metod w tym kontrolerze
class ApiCategoryController extends AbstractController // Deklarujemy klasę kontrolera kategorii, która dziedziczy po AbstractController
{
    // 1. POBIERANIE WSZYSTKICH KATEGORII
    #[Route('', name: 'index', methods: ['GET'])] // Nasłuchujemy na metodę GET pod adresem głównym '/api/categories'
    public function index(EntityManagerInterface $entityManager): JsonResponse // Wstrzykujemy połączenie z bazą, deklarujemy zwrot typu JsonResponse
    {
        $categories = $entityManager->getRepository(Category::class)->findAll(); // Pobieramy absolutnie wszystkie kategorie z bazy danych
        $data = []; // Tworzymy pustą tablicę, która posłuży nam za worek na sformatowane dane

        foreach ($categories as $category) { // Pętlą przechodzimy przez każdy pojedynczy obiekt kategorii wyciągnięty z bazy
            $data[] = [ // Dodajemy nową pod-tablicę do naszego głównego worka $data
                'id' => $category->getId(), // Zapisujemy pod kluczem 'id' numer identyfikacyjny kategorii
                'name' => $category->getName(), // Zapisujemy pod kluczem 'name' nazwę kategorii
            ]; // Zamykamy definicję danych dla tego konkretnego obiektu
        } // Zamykamy pętlę foreach

        return $this->json($data); // Zwracamy naszą wypełnioną tablicę automatycznie przekonwertowaną na tekstowy format JSON
    } // Zamykamy funkcję index

    // 2. DODAWANIE NOWEJ KATEGORII
    #[Route('', name: 'create', methods: ['POST'])] // Nasłuchujemy na żądania POST, które służą do wysyłania nowych danych
    public function create(Request $request, EntityManagerInterface $entityManager): JsonResponse // Pobieramy żądanie z danymi oraz menedżer bazy
    {
        $data = json_decode($request->getContent(), true); // Dekodujemy odebrany od użytkownika ciąg JSON na tablicę PHP

        if (empty($data['name'])) { // Sprawdzamy warunkiem, czy użytkownik "zapomniał" przesłać pole z nazwą kategorii
            return $this->json(['message' => 'Brak nazwy kategorii'], 400); // Jeśli zapomniał, rzucamy błędem 400 (Bad Request) i przerywamy skrypt
        } // Zamykamy instrukcję warunkową

        $category = new Category(); // Tworzymy nową, pustą instancję modelu Category w pamięci RAM
        $category->setName($data['name']); // Ustawiamy nazwę tej kategorii na wartość wpisaną przez użytkownika w zapytaniu

        $entityManager->persist($category); // Zgłaszamy menedżerowi Doctrine, że mamy nowy obiekt gotowy do wysłania do bazy
        $entityManager->flush(); // Fizycznie wykonujemy zapis do pliku bazy SQLite (zapytanie INSERT)

        return $this->json(['message' => 'Kategoria dodana', 'id' => $category->getId()], 201); // Zwracamy komunikat sukcesu z kodem 201 (Created)
    } // Zamykamy funkcję create

    // 3. USUWANIE KATEGORII (Skrócony CRUD, pominąłem Update i Show dla zwięzłości, są opcjonalne)
    #[Route('/{id}', name: 'delete', methods: ['DELETE'])] // Endpoint przyjmujący dynamiczne ID i reagujący tylko na metodę DELETE
    public function delete(EntityManagerInterface $entityManager, int $id): JsonResponse // Wymagamy menedżera bazy i numeru ID jako liczby całkowitej
    {
        $category = $entityManager->getRepository(Category::class)->find($id); // Szukamy w bazie kategorii o podanym ID

        if (!$category) { // Jeśli wyszukiwanie zwróciło fałsz (kategoria nie istnieje)
            return $this->json(['message' => 'Nie znaleziono kategorii'], 404); // Zwracamy błąd 404 (Not Found)
        } // Zamykamy sprawdzenie

        $entityManager->remove($category); // Instruujemy bazę, aby zaznaczyła tę kategorię do skasowania
        $entityManager->flush(); // Fizycznie wykonujemy zapytanie DELETE na pliku bazy danych

        return $this->json(['message' => 'Kategoria usunięta']); // Oddajemy użytkownikowi odpowiedź potwierdzającą sukces
    } // Zamykamy funkcję delete
} // Zamykamy klasę ApiCategoryController
