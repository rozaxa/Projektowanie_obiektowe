import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


@pytest.fixture(scope="module")
def driver():
    options = Options()
    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    driver = webdriver.Chrome(options=options)
    yield driver
    driver.quit()


def test_title(driver):
    driver.get("https://the-internet.herokuapp.com/")
    WebDriverWait(driver, 10).until(EC.title_contains("The Internet"))
    assert "The Internet" in driver.title


def test_heading(driver):
    driver.get("https://the-internet.herokuapp.com/")
    h1 = driver.find_element(By.TAG_NAME, "h1").text
    assert h1.strip() == "Welcome to the-internet"


def test_add_remove_elements(driver):
    driver.get("https://the-internet.herokuapp.com/add_remove_elements/")
    driver.find_element(By.XPATH, "//button[text()='Add Element']").click()
    delete_btn = driver.find_element(By.CLASS_NAME, "added-manually")
    assert delete_btn.is_displayed()


def test_checkbox(driver):
    driver.get("https://the-internet.herokuapp.com/checkboxes")
    cb = driver.find_elements(By.CSS_SELECTOR, "input[type='checkbox']")[0]
    if not cb.is_selected():
        cb.click()
    assert cb.is_selected()


def test_iframe_input(driver):
    driver.get("https://the-internet.herokuapp.com/iframe")
    driver.switch_to.frame("mce_0_ifr")
    body = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "tinymce"))
    )

    driver.execute_script(
        "arguments[0].innerHTML = arguments[1];",
        body,
        "Hello Selenium!"
    )
    text = driver.execute_script("return arguments[0].innerText;", body)
    assert "Hello Selenium!" in text

    driver.switch_to.default_content()


def test_dynamic_loading(driver):
    driver.get("https://the-internet.herokuapp.com/dynamic_loading/1")
    driver.find_element(By.TAG_NAME, "button").click()
    WebDriverWait(driver, 10).until(
        EC.text_to_be_present_in_element((By.ID, "finish"), "Hello World!")
    )
    finish = driver.find_element(By.ID, "finish").text
    assert "Hello World!" in finish


def test_login_failure(driver):
    driver.get("https://the-internet.herokuapp.com/login")
    driver.find_element(By.ID, "username").send_keys("invalid")
    driver.find_element(By.ID, "password").send_keys("wrong")
    driver.find_element(By.CLASS_NAME, "radius").click()
    flash = WebDriverWait(driver, 10).until(
        EC.visibility_of_element_located((By.ID, "flash"))
    ).text.lower()
    assert "your username is invalid" in flash


def test_login_success(driver):
    driver.get("https://the-internet.herokuapp.com/login")
    driver.find_element(By.ID, "username").send_keys("tomsmith")
    driver.find_element(By.ID, "password").send_keys("SuperSecretPassword!")
    driver.find_element(By.CLASS_NAME, "radius").click()
    flash = WebDriverWait(driver, 10).until(
        EC.visibility_of_element_located((By.ID, "flash"))
    ).text.lower()
    assert "you logged into a secure area" in flash




def test_elemental_selenium_footer_link(driver):
    driver.get("https://the-internet.herokuapp.com/")
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    link = WebDriverWait(driver, 5).until(
        EC.visibility_of_element_located((By.LINK_TEXT, "Elemental Selenium"))
    )
    href = link.get_attribute("href")
    assert href == "http://elementalselenium.com/"

def test_404_page(driver):
    driver.get("https://the-internet.herokuapp.com/nonexistentpage")
    heading = driver.find_element(By.TAG_NAME, "h1").text
    assert "Not Found" in heading
