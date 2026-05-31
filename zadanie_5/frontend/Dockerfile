# Budujemy warstwę frontendową z wykorzystaniem minimalnego obrazu zawierającego Node.js w wersji zgodnej z react-router-dom 7
FROM node:20-alpine

# Analogicznie do backendu, ustawiamy katalog "/app" jako serce operacji plikowych na frontendzie
WORKDIR /app

# Przenosimy do kontenera listę bibliotek (React, react-router-dom) przed przeniesieniem samego kodu
COPY package*.json ./

# Odpalamy polecenie "npm install", które pobierze wszystkie tysiące małych plików bibliotek do folderu "node_modules" wewnątrz kontenera
RUN npm install

# Gdy ciężkie instalacje bibliotek są gotowe, kopiujemy nasze pliki z komponentami React (wszystko inne z katalogu)
COPY . .

# Dokumentujemy zamiar użycia portu 3000 (standardowy port tworzony przez serwer deweloperski create-react-app)
EXPOSE 3000

# Domyślna komenda włączająca środowisko React po tym, jak kontener frontendowy zacznie "żyć"
CMD ["npm", "start"]
