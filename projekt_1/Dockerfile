FROM ubuntu:22.04
# używamy obrazu systemu Ubuntu jako bazy

RUN apt update
# aktualizacja listy pakietów

RUN apt install -y fp-compiler
# instalacja kompilatora FreePascal

WORKDIR /app
# ustawienie katalogu roboczego w kontenerze

COPY . .
# kopiujemy wszystkie pliki projektu do kontenera

RUN fpc program.pas
# kompilacja programu Pascal

RUN fpc tests.pas
# kompilacja testów

CMD ["bash"]
# domyślna komenda uruchamiająca bash
