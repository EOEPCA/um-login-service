*** Settings ***

Library  SeleniumLibrary
Library  Process
Library  OperatingSystem
Library  Collections

*** Variables ***

*** Test Cases ***

Access Login Service with Credentials
  UMA Get Data from Config File
  ${chrome_options} =  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
  Call Method  ${chrome_options}  add_argument  headless
  Call Method  ${chrome_options}  add_argument  disable-gpu
  Call Method  ${chrome_options}  add_argument  disable-dev-shm-usage
  Call Method  ${chrome_options}  add_argument  no-startup-window
  Call Method  ${chrome_options}  add_argument  no-sandbox
  Call Method  ${chrome_options}  add_argument  ignore-certificate-errors
  ${options}=  Call Method  ${chrome_options}  to_capabilities      
  Open Browser  ${URL}  browser=chrome  desired_capabilities=${options}
  Set Browser Implicit Wait  5
  LoginService Fill Credentials
  LoginService Enter Profile Page
  LoginService Call Log out Button

*** Keywords ***

UMA Get Data from Config File
  ${data}=  OperatingSystem.Get File  ./config.json
  ${json}=  Evaluate  json.loads('''${data}''')  json
  ${URL}=  Get From Dictionary  ${json}  hostname
  ${USER}=  Get From Dictionary  ${json}  username
  ${PWD}=  Get From Dictionary  ${json}  password
  Set Global Variable  ${URL}
  Set Global Variable  ${USER} 
  Set Global Variable  ${PWD}

LoginService Enter Profile Page
  Title Should Be  Gluu
  Click Element  id=menuPersonal
  Click Element  id=subMenuPersonal
  Set Browser Implicit Wait  2

LoginService Fill Credentials
  TItle Should Be  oxAuth - Passport Login
  Input Text  id=loginForm:username  admin
  Input Password  id=loginForm:password  admin_Abcd1234#
  Click Button  id=loginForm:loginButton
  Set Browser Implicit Wait  3

LoginService Call Log out Button
  Title Should Be  Gluu
  Click Element  xpath=//a[@class="dropdown-toggle"]
  Set Browser Implicit Wait  1
  Click Element  id=j_idt14:j_idt29
  Set Browser Implicit Wait  1


