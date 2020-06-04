from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
import time


caps = webdriver.DesiredCapabilities.CHROME.copy()
caps['acceptInsecureCerts'] = True

#


chrome_options = Options()
chrome_options.add_argument('--headless')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')

#driver = webdriver.Chrome(ChromeDriverManager().install(), chrome_options=chrome_options)
driver = webdriver.Chrome('chromedriver',desired_capabilities=caps, chrome_options=chrome_options)
#driver = webdriver.Chrome(executable_path=r'chromedriver')

driver.get('https://demoexample.gluu.org')

# print messages
#driver.get("https://www.python.org")
try:
    element = WebDriverWait(driver, 10)
    
    print(driver.title)
    
    username = driver.find_element_by_id("loginForm:username")
    password = driver.find_element_by_id("loginForm:password")
    submit   = driver.find_element_by_id("loginForm:loginButton")
    username.send_keys("alvlDemo")
    password.send_keys("alvl")
    submit.click()
    time.sleep(15)
    
finally:
    print(driver.title)
    if driver.title == 'Gluu':
        print('Success')
        assert driver.title == 'Gluu'
        page_title = driver.find_element_by_name('j_idt14')
    else:
        fail = driver.find_element_by_xpath('//li[@class="text-center"]')
    driver.quit()



