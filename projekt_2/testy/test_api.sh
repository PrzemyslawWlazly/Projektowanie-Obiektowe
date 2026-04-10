#!/bin/bash
# Powyższa linijka musi być zawsze sama - informuje system, że to skrypt Bash.

# Wyświetla na ekranie tytuł testu
echo "=== 1. TEST DODAWANIA PIERWSZEGO PRODUKTU ===" 
# Wrzuca do API (POST) dane nowego produktu w formacie JSON
curl -X POST http://127.0.0.1:8000/api/products -H "Content-Type: application/json" -d '{"name": "Laptop", "price": 4500}' 
# Wypisuje w terminalu puste linie (odstęp)
echo -e "\n\n" 

# Wyświetla tytuł kolejnego etapu
echo "=== 2. TEST DODAWANIA DRUGIEGO PRODUKTU ===" 
# Dodaje do bazy myszkę za 150
curl -X POST http://127.0.0.1:8000/api/products -H "Content-Type: application/json" -d '{"name": "Myszka", "price": 150}' 
echo -e "\n\n" 

# Pobieramy dane
echo "=== 3. TEST POBIERANIA WSZYSTKICH PRODUKTÓW ===" 
# Wykonuje żądanie GET, by pobrać wszystko
curl -X GET http://127.0.0.1:8000/api/products 
echo -e "\n\n" 

# Test aktualizacji
echo "=== 4. TEST EDYCJI PRODUKTU (Zakładamy, że Laptop ma ID = 1) ===" 
# Używa metody PUT, obniżając cenę laptopa na 4000
curl -X PUT http://127.0.0.1:8000/api/products/1 -H "Content-Type: application/json" -d '{"price": 4000}' 
echo -e "\n\n" 

# Próba pobrania detali tylko jednego elementu
echo "=== 5. TEST POBIERANIA JEDNEGO PRODUKTU ===" 
# Zwraca dane produktu pod ID 1
curl -X GET http://127.0.0.1:8000/api/products/1 
echo -e "\n\n" 

# Test niszczący dane
echo "=== 6. TEST USUWANIA PRODUKTU (Zakładamy, że Myszka ma ID = 2) ===" 
# Używa metody DELETE na produkcie o identyfikatorze 2
curl -X DELETE http://127.0.0.1:8000/api/products/2 
echo -e "\n\n" 

# Podsumowanie operacji
echo "=== 7. SPRAWDZENIE BAZY PO USUNIĘCIU ===" 
# Ostatni raz pobiera listę produktów, aby udowodnić, że Myszka zniknęła
curl -X GET http://127.0.0.1:8000/api/products 
echo -e "\n"
