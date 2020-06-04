from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
import json
import time

with open('test_settings.json', 'r') as config:
    config=config.read()
# parse x:
y = json.loads(config)

hostname = y['hostname']
username = y['username']
password = y['password']

#Properties for the chrome driver
caps = webdriver.DesiredCapabilities.CHROME.copy()
caps['acceptInsecureCerts'] = True
chrome_options = Options()
chrome_options.add_argument('--headless')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')

#Set the driver with the properties above
driver = webdriver.Chrome('chromedriver',desired_capabilities=caps, chrome_options=chrome_options)
#Match the gluu instance

driver.get(hostname)

try:
    #Sleep until credentials are processed
    element = WebDriverWait(driver, 10)
    print(driver.title)
    #Matches the login form elemnents
    u = driver.find_element_by_id("loginForm:username")
    p = driver.find_element_by_id("loginForm:password")
    submit   = driver.find_element_by_id("loginForm:loginButton")
    #Fill username and password with the user to test
    u.send_keys(username)
    p.send_keys(password)
    submit.click()
    #Wait until the Authorization is made
    time.sleep(15)
    
finally:
    print(driver.title)
    if driver.title == 'Gluu':
        #The main page's title matches the expected
        print('Success')
        assert driver.title == 'Gluu'
        driver.find_element_by_name('j_idt14')
    else:
        #Check if the message was unauthorized
        fail = driver.find_element_by_xpath('//li[@class="text-center"]')
        print('Wrong User or Password')
    driver.quit()



