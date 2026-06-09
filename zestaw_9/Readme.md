
-----------------------


## Zadanie 9: Chmura, Docker i GitHub Actions

[Link do głównego folderu projektu](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/tree/main/zestaw_9)

✅ **3.0 Należy stworzyć odpowiednie instancje po stronie chmury na Dockerze**
* [Konfiguracja Docker Compose](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_9/docker-compose.yml)
* [Dockerfile aplikacji serwerowej](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_9/backend/Dockerfile)
* [Kod aplikacji serwerowej przygotowany do działania w chmurze](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_9/backend/main.go)
* [Dockerfile aplikacji klienckiej](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_9/frontend/Dockerfile)
* [Konfiguracja serwera Nginx](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/zestaw_9/frontend/nginx.conf)
* [Uruchomiona aplikacja serwerowa na Render](https://zestaw9-backend.onrender.com/api/products)
* [Uruchomiona aplikacja kliencka na Render](https://zestaw9-frontend.onrender.com)


<img width="1841" height="996" alt="obiektowe_zest9_30_scr2" src="https://github.com/user-attachments/assets/9ab8583f-3248-4817-b774-46199065c04a" />



✅ **3.5 Stworzyć odpowiedni pipeline w GitHub Actions do budowania aplikacji**
* [Pipeline budujący obrazy Docker aplikacji klienckiej i serwerowej](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/.github/workflows/zestaw9-build.yml)
* [Historia uruchomień GitHub Actions](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/actions/workflows/zestaw9-build.yml)




<img width="1841" height="996" alt="obiektowe_zest_9_35" src="https://github.com/user-attachments/assets/5676b602-2a27-410c-a005-a477963bddd7" />

✅ **4.0 Dodać notyfikację mailową o zbudowaniu aplikacji**
* [Konfiguracja powiadomienia e-mail w GitHub Actions](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/.github/workflows/zestaw9-build.yml)
* Dane logowania do serwera SMTP są przechowywane bezpiecznie jako sekrety repozytorium GitHub: `MAIL_USERNAME`, `MAIL_PASSWORD` oraz `MAIL_TO`.





<img width="1805" height="358" alt="Screenshot from 2026-06-09 19-13-57" src="https://github.com/user-attachments/assets/fa99b825-a553-4ac9-a7e9-5ebb844b6b63" />

✅ **4.5 Dodać krok z deploymentem aplikacji serwerowej oraz klienckiej na chmurę**
* [Kroki deploymentu backendu i frontendu na Render](https://github.com/PrzemyslawWlazly/Projektowanie-Obiektowe/blob/main/.github/workflows/zestaw9-build.yml)
* Deployment jest uruchamiany po poprawnym zbudowaniu aplikacji za pomocą Render Deploy Hooks.
* Adresy hooków są przechowywane jako sekrety `RENDER_BACKEND_DEPLOY_HOOK` oraz `RENDER_FRONTEND_DEPLOY_HOOK`.
* [Wdrożony backend](https://zestaw9-backend.onrender.com/api/products)
* [Wdrożony frontend](https://zestaw9-frontend.onrender.com)





<img width="1805" height="630" alt="Screenshot from 2026-06-09 19-45-26" src="https://github.com/user-attachments/assets/5b7e802f-2394-4c75-b5a7-a196bce56427" />
<img width="1805" height="996" alt="Screenshot from 2026-06-09 19-47-38" src="https://github.com/user-attachments/assets/1dc74669-a2d4-4ee0-8a28-44b415f81e55" />
<img width="1805" height="996" alt="Screenshot from 2026-06-09 19-48-31" src="https://github.com/user-attachments/assets/dca55424-3e40-4763-af38-ad7ebadd9c25" />


❌ **5.0 Dodać uruchomienie regresyjnych testów automatycznych (funkcjonalnych) jako krok w Actions**
* Punkt nie został zrealizowany.****
