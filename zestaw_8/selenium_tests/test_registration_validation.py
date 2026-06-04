import os
import shutil
import tempfile

import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait


BASE_URL = os.getenv("APP_URL", "http://localhost:3000")


@pytest.fixture
def driver():
    # Konfigurujemy przeglądarkę Chrome w trybie headless, aby testy mogły działać także w CI lub w terminalu.
    options = Options()
    if os.getenv("SHOW_BROWSER") != "1":
        # Domyślnie uruchamiamy testy bez widocznego okna, żeby wynik był stabilny w terminalu.
        options.add_argument("--headless=new")
    options.add_argument("--window-size=1280,900")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-gpu")
    options.add_argument("--remote-debugging-port=0")

    # Każdy test dostaje osobny profil Chromium, aby poprzednia sesja lub ręcznie otwarta przeglądarka nie blokowała WebDrivera.
    # Profil trzymamy w katalogu danych snapa Chromium, bo snap nie może swobodnie zapisywać profilu w zwykłym /tmp albo ~/.cache.
    profile_root = os.path.join(os.path.expanduser("~"), "snap", "chromium", "common", "selenium-profiles")
    os.makedirs(profile_root, exist_ok=True)
    user_data_dir = tempfile.mkdtemp(prefix="profile-", dir=profile_root)
    options.add_argument(f"--user-data-dir={user_data_dir}")

    # Na Ubuntu Chromium bywa instalowany jako snap, dlatego jawnie wskazujemy binarkę i chromedrivera, jeśli istnieją.
    chromium_binary = shutil.which("chromium") or shutil.which("chromium-browser")
    chromium_driver = shutil.which("chromium.chromedriver") or shutil.which("chromedriver")

    if chromium_binary and os.path.basename(chromium_driver or "") != "chromium.chromedriver":
        # Ustawiamy lokalizację przeglądarki tylko dla zwykłego chromedrivera; snapowy chromium.chromedriver sam znajduje właściwe Chromium.
        options.binary_location = chromium_binary

    if chromium_driver:
        # Używamy sterownika dostarczonego razem z Chromium, co usuwa typowy błąd SessionNotCreatedException przy snapie.
        service = Service(chromium_driver)
        browser = webdriver.Chrome(service=service, options=options)
    else:
        # Jeżeli nie ma lokalnego chromedrivera, Selenium Manager spróbuje dobrać sterownik automatycznie.
        browser = webdriver.Chrome(options=options)

    try:
        yield browser
    finally:
        # Zawsze zamykamy proces przeglądarki, aby kolejne uruchomienia testów nie zostawiały wiszących sesji.
        browser.quit()
        shutil.rmtree(user_data_dir, ignore_errors=True)


def open_registration_form(driver):
    # Otwieramy bezpośrednio trasę formularza, ponieważ test dotyczy walidacji rejestracji, a nie menu nawigacji.
    driver.get(f"{BASE_URL}/register")

    # Czekamy na wyrenderowanie formularza Reacta, żeby asercje nie ścigały się z ładowaniem aplikacji.
    return WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "registration-form"))
    )


def test_registration_required_fields_are_validated(driver):
    # Przygotowanie: przechodzimy na stronę rejestracji i pobieramy element formularza.
    form = open_registration_form(driver)

    # Pobieramy obowiązkowe pola po identyfikatorach, które są stabilne i opisowe.
    name_input = driver.find_element(By.ID, "register-name")
    email_input = driver.find_element(By.ID, "register-email")
    password_input = driver.find_element(By.ID, "register-password")
    submit_button = driver.find_element(By.CSS_SELECTOR, "[data-testid='registration-submit']")

    # Akcja: klikamy wysłanie pustego formularza, co powinno uruchomić natywną walidację HTML5.
    submit_button.click()

    # Asercja: cały formularz pozostaje niepoprawny, ponieważ wszystkie wymagane pola są puste.
    assert driver.execute_script("return arguments[0].checkValidity();", form) is False

    # Asercja: każde pole obowiązkowe jest oznaczone przez przeglądarkę jako niepoprawne.
    assert driver.execute_script("return arguments[0].validity.valueMissing;", name_input) is True
    assert driver.execute_script("return arguments[0].validity.valueMissing;", email_input) is True
    assert driver.execute_script("return arguments[0].validity.valueMissing;", password_input) is True

    # Asercja: aplikacja nie pokazuje komunikatu sukcesu, bo rejestracja nie powinna przejść bez danych.
    assert driver.find_elements(By.CSS_SELECTOR, "[data-testid='registration-success']") == []


def test_registration_rejects_invalid_email_format(driver):
    # Przygotowanie: otwieramy formularz i wypełniamy pola tak, aby jedynym błędem był format adresu e-mail.
    form = open_registration_form(driver)
    driver.find_element(By.ID, "register-name").send_keys("Jan Testowy")
    email_input = driver.find_element(By.ID, "register-email")
    email_input.send_keys("niepoprawny-email")
    driver.find_element(By.ID, "register-password").send_keys("bezpiecznehaslo")

    # Akcja: próbujemy wysłać formularz z adresem bez poprawnej części domenowej.
    driver.find_element(By.CSS_SELECTOR, "[data-testid='registration-submit']").click()

    # Asercja: formularz pozostaje niepoprawny z powodu błędnego typu pola e-mail.
    assert driver.execute_script("return arguments[0].checkValidity();", form) is False
    assert driver.execute_script("return arguments[0].validity.typeMismatch;", email_input) is True

    # Asercja: pole e-mail pasuje do selektora :invalid, czyli przeglądarka realnie blokuje wysłanie danych.
    assert email_input.value_of_css_property("border-color") != ""
    assert driver.execute_script("return arguments[0].matches(':invalid');", email_input) is True

    # Asercja: komunikat sukcesu nadal się nie pojawia, bo aplikacja nie zaakceptowała błędnego e-maila.
    assert driver.find_elements(By.CSS_SELECTOR, "[data-testid='registration-success']") == []


def test_registration_preview_escapes_xss_payload(driver):
    # Przygotowanie: otwieramy formularz rejestracji i ustawiamy znacznik, który payload XSS próbowałby zmienić.
    open_registration_form(driver)
    driver.execute_script("window.__xssExecuted = false; window.alert = function() { window.__xssExecuted = true; };")

    # Przygotowujemy klasyczny payload z elementem img i zdarzeniem onerror, który wykonałby JavaScript przy niebezpiecznym HTML.
    xss_payload = '<img src=x onerror="window.__xssExecuted=true;alert(\'xss\')">'

    # Akcja: wpisujemy payload w pole tekstowe, a pozostałe pola wypełniamy poprawnie, żeby formularz przeszedł walidację.
    driver.find_element(By.ID, "register-name").send_keys(xss_payload)
    driver.find_element(By.ID, "register-email").send_keys("xss-test@example.com")
    driver.find_element(By.ID, "register-password").send_keys("bezpiecznehaslo")
    driver.find_element(By.CSS_SELECTOR, "[data-testid='registration-submit']").click()

    # Czekamy na podgląd rejestracji, czyli miejsce, w którym złośliwy tekst został wyrenderowany przez aplikację React.
    preview = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.CSS_SELECTOR, "[data-testid='registration-preview']"))
    )
    preview_name = driver.find_element(By.CSS_SELECTOR, "[data-testid='registration-preview-name']")

    # Asercja: payload pozostaje zwykłym tekstem, a React nie zamienia go na prawdziwy element HTML.
    assert preview_name.text == xss_payload
    assert preview.find_elements(By.TAG_NAME, "img") == []

    # Asercja: kod JavaScript z payloadu nie został wykonany i nie wywołał podmienionej funkcji alert.
    assert driver.execute_script("return window.__xssExecuted;") is False


def test_cart_state_is_consistent_between_browser_tabs(driver):
    # Przygotowanie: otwieramy asortyment i czyścimy localStorage, aby test wielokartowy startował z pustym koszykiem.
    driver.get(BASE_URL)
    driver.execute_script("window.localStorage.clear();")
    driver.refresh()

    # Czekamy na produkty pobrane z backendu i dodajemy pierwszą pozycję w pierwszej karcie.
    first_add_button = WebDriverWait(driver, 10).until(
        EC.element_to_be_clickable((By.CSS_SELECTOR, "[data-testid='add-to-cart-1']"))
    )
    first_add_button.click()
    first_tab = driver.current_window_handle

    # Otwieramy drugą kartę tej samej przeglądarki, która powinna odczytać koszyk zapisany w localStorage.
    driver.switch_to.new_window("tab")
    second_tab = driver.current_window_handle
    driver.get(f"{BASE_URL}/cart")

    # Asercja: druga karta widzi produkt dodany wcześniej w pierwszej karcie.
    WebDriverWait(driver, 10).until(
        lambda active_driver: len(active_driver.find_elements(By.CSS_SELECTOR, "[data-testid='cart-item']")) == 1
    )
    assert "Różdżka treningowa" in driver.find_element(By.CSS_SELECTOR, "[data-testid='cart-item']").text
    assert "150.00 PLN" in driver.find_element(By.CSS_SELECTOR, "[data-testid='cart-total']").text

    # Akcja: wracamy do pierwszej karty i dodajemy drugi produkt, gdy druga karta z koszykiem pozostaje otwarta.
    driver.switch_to.window(first_tab)
    second_add_button = WebDriverWait(driver, 10).until(
        EC.element_to_be_clickable((By.CSS_SELECTOR, "[data-testid='add-to-cart-2']"))
    )
    second_add_button.click()

    # Asercja: druga karta aktualizuje koszyk po zdarzeniu storage bez ręcznego odświeżania strony.
    driver.switch_to.window(second_tab)
    WebDriverWait(driver, 10).until(
        lambda active_driver: len(active_driver.find_elements(By.CSS_SELECTOR, "[data-testid='cart-item']")) == 2
    )
    assert "1350.00 PLN" in driver.find_element(By.CSS_SELECTOR, "[data-testid='cart-total']").text

    # Akcja: usuwamy pierwszą pozycję w drugiej karcie, aby sprawdzić synchronizację również w drugą stronę.
    driver.find_element(By.CSS_SELECTOR, "[data-testid='remove-from-cart-0']").click()
    WebDriverWait(driver, 10).until(
        lambda active_driver: len(active_driver.find_elements(By.CSS_SELECTOR, "[data-testid='cart-item']")) == 1
    )

    # Asercja: pierwsza karta po przejściu do koszyka widzi ten sam, pomniejszony stan zamówienia.
    driver.switch_to.window(first_tab)
    driver.get(f"{BASE_URL}/cart")
    WebDriverWait(driver, 10).until(
        lambda active_driver: len(active_driver.find_elements(By.CSS_SELECTOR, "[data-testid='cart-item']")) == 1
    )
    assert "Miotła sportowa" in driver.find_element(By.CSS_SELECTOR, "[data-testid='cart-item']").text
    assert "1200.00 PLN" in driver.find_element(By.CSS_SELECTOR, "[data-testid='cart-total']").text


def test_csrf_attack_link_cannot_change_account_settings_with_active_session(driver):
    # Przygotowanie: czyścimy stan przeglądarki, aby test CSRF startował od świeżej sesji i domyślnych ustawień konta.
    driver.get(BASE_URL)
    driver.execute_script("window.localStorage.clear();")

    # Logujemy użytkownika w pierwszej karcie, ponieważ atak CSRF zakłada aktywną sesję ofiary.
    driver.get(f"{BASE_URL}/login")
    WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "login-form"))
    )
    driver.find_element(By.ID, "login-email").send_keys("csrf-test@example.com")
    driver.find_element(By.ID, "login-password").send_keys("bezpiecznehaslo")
    driver.find_element(By.CSS_SELECTOR, "[data-testid='login-submit']").click()
    WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.CSS_SELECTOR, "[data-testid='login-session']"))
    )
    first_tab = driver.current_window_handle

    # Wykonujemy poprawną zmianę ustawień przez formularz z prawidłowym tokenem CSRF, aby mieć stan bazowy do porównania.
    driver.get(f"{BASE_URL}/account")
    display_name_input = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "account-display-name"))
    )
    display_name_input.clear()
    display_name_input.send_keys("Bezpieczna nazwa")
    marketing_checkbox = driver.find_element(By.ID, "marketing-consent")
    if not marketing_checkbox.is_selected():
        marketing_checkbox.click()
    driver.find_element(By.CSS_SELECTOR, "[data-testid='account-save']").click()
    WebDriverWait(driver, 10).until(
        EC.text_to_be_present_in_element((By.CSS_SELECTOR, "[data-testid='saved-display-name']"), "Bezpieczna nazwa")
    )
    assert driver.find_element(By.CSS_SELECTOR, "[data-testid='saved-marketing-consent']").text == "tak"

    # Otwieramy spreparowany link w drugiej karcie tej samej przeglądarki, czyli przy nadal aktywnej sesji użytkownika.
    driver.switch_to.new_window("tab")
    malicious_link = (
        f"{BASE_URL}/account?"
        "displayName=Atak-CSRF&marketingConsent=false&csrfToken=falszywy-token"
    )
    driver.get(malicious_link)

    # Asercja: aplikacja rozpoznaje parametry w URL jako niedozwoloną próbę zmiany i pokazuje ostrzeżenie.
    WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.CSS_SELECTOR, "[data-testid='csrf-warning']"))
    )

    # Asercja: ustawienia pozostają takie jak po legalnym zapisie, mimo że link próbował podać nowe wartości.
    assert driver.find_element(By.CSS_SELECTOR, "[data-testid='saved-display-name']").text == "Bezpieczna nazwa"
    assert driver.find_element(By.CSS_SELECTOR, "[data-testid='saved-marketing-consent']").text == "tak"
    assert driver.find_element(By.ID, "account-display-name").get_attribute("value") == "Bezpieczna nazwa"
    assert driver.find_element(By.ID, "marketing-consent").is_selected() is True

    # Asercja: localStorage także nie zawiera wartości z ataku, więc zmiana nie została zapisana ukrytym skutkiem ubocznym.
    stored_settings = driver.execute_script("return window.localStorage.getItem('magic-shop-account-settings');")
    assert "Atak-CSRF" not in stored_settings
    assert "Bezpieczna nazwa" in stored_settings

    # Wracamy do pierwszej karty i sprawdzamy, że oryginalna sesja również widzi niezmienione ustawienia.
    driver.switch_to.window(first_tab)
    driver.get(f"{BASE_URL}/account")
    WebDriverWait(driver, 10).until(
        EC.text_to_be_present_in_element((By.CSS_SELECTOR, "[data-testid='saved-display-name']"), "Bezpieczna nazwa")
    )
    assert driver.find_element(By.CSS_SELECTOR, "[data-testid='saved-marketing-consent']").text == "tak"
