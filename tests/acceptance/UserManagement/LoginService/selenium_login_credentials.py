from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
import json
from json import load, dump
import time
from eoepca_scim import EOEPCA_Scim, ENDPOINT_AUTH_CLIENT_POST


def load_config(config_path: str) -> dict:
    """
    Parses and returns the config file

    Returns: dict
    """
    config = {}
    with open(config_path) as j:
        config = load(j)

    return config


def save_config(config_path: str, data: dict):
    """
    Saves updated config file
    """
    with open(config_path, 'w') as j:
        dump(data,j)


y = load_config("config.json")


if "client_id" not in y or "client_secret" not in y:
    print ("NOTICE: Client not found, generating one... ")
    scim_client = EOEPCA_Scim(y["hostname"])
    new_client = scim_client.registerClient("Selenium Test Client",
                                    grantTypes = ["client_credentials", "password", "urn:ietf:params:oauth:grant-type:uma-ticket"],
                                    redirectURIs = [""],
                                    logoutURI = "", 
                                    responseTypes = ["code","token","id_token"],
                                    scopes = ['openid',  'email', 'user_name ','uma_protection', 'permission'],
                                    token_endpoint_auth_method = ENDPOINT_AUTH_CLIENT_POST)
    print("NEW CLIENT created with ID '"+new_client["client_id"]+"', since no client config was found on config.json")

    y["client_id"] = new_client["client_id"]
    y["client_secret"] = new_client["client_secret"]
    save_config("config.json", y)
    print("New client saved to config!")
else:
    print("Client found in config, using: "+y["client_id"])


#Properties for the chrome driver
caps = webdriver.DesiredCapabilities.CHROME.copy()
caps['acceptInsecureCerts'] = True
chrome_options = Options()
chrome_options.add_argument('--headless')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')

#Set the driver with the properties above
driver = webdriver.Chrome('/usr/local/bin/chromedriver',desired_capabilities=caps, chrome_options=chrome_options)

def normal_login(driver, config):
    
    hostname = config['hostname']
    username = config['username']
    password = config['password']
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
            print('Reached Gluu Main Page')
            assert driver.title == 'Gluu'
            driver.find_element_by_name('j_idt14')
        else:
            #Check if the message was unauthorized
            fail = driver.find_element_by_xpath('//li[@class="text-center"]')
            print(fail.text)
            print('Wrong User or Password')
        

def git_login(driver, config):
    
    hostname = config['hostname']
    git_user= config['git_username']
    git_pwd= config['git_password']
    driver.get(hostname)

    try:
        #Sleep until credentials are processed
        element = WebDriverWait(driver, 10)
        print(driver.title)
        # people = driver.find_element_by_xpath("//*[@id=\"stakeholders\"]/h4").getAttribute("innerHTML");
        # a = driver.find_element_by_xpath('//li[@class="text-center"]')
        a = driver.find_element_by_xpath('//img[@style="cursor:pointer;max-width:48px"]')
        a.click()
        time.sleep(5)
        print(driver.title)
        u = driver.find_element_by_id("login_field")
        p = driver.find_element_by_id("password")
        sub = driver.find_element_by_xpath('//input[@class="btn btn-primary btn-block"]')
        

        u.send_keys(git_user)
        p.send_keys(git_pwd)
        sub.click()
        #Wait until the
        element = WebDriverWait(driver, 10)
        time.sleep(10)
        
    

    finally:
        #driver.quit()
        
        print(driver.title)

def from_gluu_check_user(driver):
    try:
        if driver.title == 'Gluu':
            #The main page's title matches the expected
            print('Logged in!')
            a=driver.find_element_by_id("menuPersonal")
            a.click()
            time.sleep(5)
            b=driver.find_element_by_id('subMenuPersonal')
            b.click()
            time.sleep(5)
            print(driver.title)
            c=driver.find_element_by_id('personForm:j_idt181')
            print('Found user profile data')
        else:
            print('Error in login')

    finally:
        print('Success!')


normal_login(driver, y)
#git_login(driver,y)
from_gluu_check_user(driver)

driver.quit()