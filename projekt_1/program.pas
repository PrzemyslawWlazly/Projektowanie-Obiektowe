program BubbleSortExample; 
{ deklaracja nazwy programu }

uses crt;
{ dołączenie biblioteki crt – umożliwia operacje wejścia/wyjścia }

type
  IntArray = array[1..100] of integer;
{ deklarujemy typ tablicy liczb całkowitych o maksymalnej wielkości 100 }

procedure GenerateRandom(var arr: IntArray; fromVal, toVal, count: integer);
{ procedura generująca liczby losowe
  arr – tablica do której zapiszemy liczby
  fromVal – minimalna wartość losowania
  toVal – maksymalna wartość losowania
  count – ile liczb wygenerować }

var
  i: integer;
{ zmienna pomocnicza do iteracji }

begin
  randomize;
  { inicjalizacja generatora liczb losowych }

  for i := 1 to count do
  begin
    arr[i] := random(toVal - fromVal + 1) + fromVal;
    { generujemy liczbę losową z zakresu odVal..toVal }
  end;
end;

procedure BubbleSort(var arr: IntArray; count: integer);
{ procedura sortująca tablicę metodą bąbelkową }

var
  i, j, temp: integer;
{ i i j – indeksy pętli
  temp – zmienna pomocnicza do zamiany elementów }

begin
  for i := 1 to count - 1 do
  begin
    for j := 1 to count - i do
    begin
      if arr[j] > arr[j + 1] then
      begin
        temp := arr[j];
        { zapamiętujemy element }

        arr[j] := arr[j + 1];
        { przesuwamy element }

        arr[j + 1] := temp;
        { wstawiamy element w nowe miejsce }
      end;
    end;
  end;
end;

procedure PrintArray(arr: IntArray; count: integer);
{ procedura wypisująca elementy tablicy }

var
  i: integer;
{ zmienna iteracyjna }

begin
  for i := 1 to count do
  begin
    write(arr[i], ' ');
    { wypisujemy element tablicy }
  end;

  writeln;
  { przejście do nowej linii }
end;

var
  numbers: IntArray;
{ tablica przechowująca liczby }

  count: integer;
{ liczba elementów }

begin

  count := 50;
  { liczba elementów zgodnie z zadaniem }

  GenerateRandom(numbers, 0, 100, count);
  { generujemy liczby od 0 do 100 }

  writeln('Lista przed sortowaniem:');
  { komunikat }

  PrintArray(numbers, count);
  { wypisanie tablicy }

  BubbleSort(numbers, count);
  { sortowanie }

  writeln('Lista po sortowaniu:');
  { komunikat }

  PrintArray(numbers, count);
  { wypisanie posortowanej tablicy }

end.
