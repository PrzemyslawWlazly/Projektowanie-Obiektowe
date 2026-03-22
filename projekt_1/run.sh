#!/bin/bash
# określenie interpretera bash

echo "Kompilacja programu..."
# komunikat

fpc program.pas
# kompilacja programu

echo "Uruchamianie programu..."
# komunikat

./program
# uruchomienie programu

echo "Uruchamianie testów..."
# komunikat

fpc tests.pas
# kompilacja testów

./tests
# uruchomienie testów
