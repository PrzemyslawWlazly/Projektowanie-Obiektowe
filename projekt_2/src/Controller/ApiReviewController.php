<?php // Rozpoczynamy plik z kodem PHP

namespace App\Controller; // Określamy wirtualny folder (przestrzeń nazw), w którym żyje nasz kontroler

use App\Entity\Review; // Pobieramy model (encję) Review, aby móc zapisywać i czytać opinie
use Doctrine\ORM\EntityManagerInterface; // Pobieramy narzędzie do komunikacji z plikiem bazy danych
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController; // Pobieramy główną klasę Symfony, by zyskać dostęp m.in. do metody $this->json()
use Symfony\Component\HttpFoundation\JsonResponse; // Pobieramy klasę odpowiedzialną za poprawne wysyłanie danych w formacie JSON
use Symfony\Component\HttpFoundation\Request; // Pobieramy klasę obsługującą dane wchodzące od użytkownika (np. z curla)
use Symfony\Component\Routing\Annotation\Route; // Pobieramy atrybut Route, aby móc przypisywać adresy URL do funkcji

#[Route('/api/reviews', name: 'api_review_')] // Ustawiamy globalny początek adresu URL dla opinii i początek nazwy dla linków
class ApiReviewController extends AbstractController // Tworzymy główną klasę naszego kontrolera dziedziczącą po AbstractController
{
    // 1. POBIERANIE WSZYSTKICH OPINII
    #[Route('', name: 'index', methods: ['GET'])] // Definiujemy główny endpoint '/api/reviews' działający tylko przy pobieraniu (GET)
    public function index(EntityManagerInterface $entityManager): JsonResponse // Wymagamy wstrzyknięcia menedżera bazy i deklarujemy zwrot JSON
    {
        $reviews = $entityManager->getRepository(Review::class)->findAll(); // Mówimy bazie: "znajdź i przynieś wszystkie rekordy z tabeli opinii"
        $data = []; // Inicjujemy pusty koszyk (tablicę) na nasze sformatowane dane

        foreach ($reviews as $review) { // Odpalamy pętlę, która przejdzie przez każdą jedną opinię pobraną z bazy
            $data[] = [ // Wrzucamy nową tablicę z danymi konkretnej opinii na sam koniec koszyka $data
                'id' => $review->getId(), // Wyciągamy identyfikator opinii i przypisujemy go do klucza 'id'
                'content' => $review->getContent(), // Wyciągamy treść (tekst) opinii i przypisujemy do klucza 'content'
                'rating' => $review->getRating(), // Wyciągamy liczbę gwiazdek (ocenę) i przypisujemy do klucza 'rating'
            ]; // Zamykamy definicję tego pojedynczego wpisu w tablicy
        } // Zamykamy pętlę przechodzącą przez obiekty

        return $this->json($data); // Zwracamy całą naszą tablicę, a Symfony automatycznie tłumaczy ją na format JSON dla przeglądarki
    } // Kończymy funkcję pobierającą wszystkie opinie

    // 2. DODAWANIE NOWEJ OPINII
    #[Route('', name: 'create', methods: ['POST'])] // Ten sam adres URL, ale reagujący tylko na wysyłanie nowych danych (POST)
    public function create(Request $request, EntityManagerInterface $entityManager): JsonResponse // Przechwytujemy dane od klienta i menedżera bazy
    {
        $data = json_decode($request->getContent(), true); // Wyciągamy "surowy" tekst wysłany przez użytkownika i dekodujemy z JSON na tablicę PHP

        if (empty($data['content']) || empty($data['rating'])) { // Sprawdzamy, czy użytkownik nie zapomniał przesłać treści LUB oceny
            return $this->json(['message' => 'Brakujące dane (content, rating)'], 400); // Jeśli brakuje danych, ucinamy działanie i zwracamy błąd 400
        } // Koniec bloku sprawdzającego błędy w przesłanych danych

        $review = new Review(); // Tworzymy całkowicie nowy, czysty obiekt opinii w pamięci aplikacji
        $review->setContent($data['content']); // Wypełniamy ten obiekt treścią, którą przesłał nam użytkownik
        $review->setRating((int) $data['rating']); // Wypełniamy obiekt oceną, rzutując ją na liczbę całkowitą (int) dla bezpieczeństwa

        $entityManager->persist($review); // Mówimy Doctrine: "przygotuj ten nowy obiekt do wstawienia do bazy danych"
        $entityManager->flush(); // Nakazujemy Doctrine natychmiastowe fizyczne zapisanie zmian w pliku SQLite (INSERT)

        return $this->json(['message' => 'Opinia dodana', 'id' => $review->getId()], 201); // Odsyłamy komunikat sukcesu z ID opinii i kodem HTTP 201
    } // Kończymy funkcję odpowiedzialną za tworzenie opinii

    // 3. USUWANIE OPINII
    #[Route('/{id}', name: 'delete', methods: ['DELETE'])] // Definiujemy adres z parametrem {id} (np. /api/reviews/5) przyjmujący tylko metodę DELETE
    public function delete(EntityManagerInterface $entityManager, int $id): JsonResponse // Oczekujemy menedżera bazy oraz konkretnego numeru ID z URL
    {
        $review = $entityManager->getRepository(Review::class)->find($id); // Prosimy bazę o odnalezienie jednej, konkretnej opinii po tym ID

        if (!$review) { // Jeśli zapytanie do bazy zwróciło pustkę (taka opinia nie istnieje)
            return $this->json(['message' => 'Nie znaleziono opinii'], 404); // Zwracamy klientowi klasyczny błąd 404 (Not Found)
        } // Koniec sprawdzenia obecności

        $entityManager->remove($review); // Zgłaszamy do Doctrine, że ten znaleziony obiekt ma zostać permanentnie usunięty
        $entityManager->flush(); // Fizycznie zatwierdzamy zmiany, wykonując zapytanie DELETE w pliku bazy

        return $this->json(['message' => 'Opinia usunięta']); // Oddajemy klientowi informację, że operacja się powiodła
    } // Zamykamy funkcję kasowania
} // Zamykamy całą klasę kontrolera opinii
