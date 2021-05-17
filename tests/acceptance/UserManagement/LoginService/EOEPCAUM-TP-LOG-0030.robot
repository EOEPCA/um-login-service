*** Settings ***

Library  SeleniumLibrary
Library  Process
Library  OperatingSystem
Library  Collections
Library  RequestsLibrary

*** Variables ***
#User Data
${USER_NAME}=  User
${FIRST_NAME}=  User
${DISPLAY_NAME}=  User
${LAST_NAME}=  User
${EMAIL}=  acceptance@test.com
${PASSWORD}=  defaultPWD
${WELL_KNOWN_PATH}=  /.well-known/uma2-configuration

*** Test Cases ***

Login Service Configuration Validation
  UMA Get Data from Config File
  Set Chrome
  Capture Page Screenshot
  LoginService Fill Credentials
  ${id_token}=  UMA Get ID Token Valid  ${URL}  ${URL}${WELL_KNOWN_PATH}  ${USER}  ${PWD}  ${CID}  ${CSEC}

*** Keywords ***
Set Chrome
  ${chrome_options} =  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
  Call Method  ${chrome_options}  add_argument  headless
  Call Method  ${chrome_options}  add_argument  disable-gpu
  Call Method  ${chrome_options}  add_argument  disable-dev-shm-usage
  Call Method  ${chrome_options}  add_argument  no-startup-window
  Call Method  ${chrome_options}  add_argument  no-sandbox
  Call Method  ${chrome_options}  add_argument  ignore-certificate-errors
  ${options}=  Call Method  ${chrome_options}  to_capabilities      
  Open Browser  ${URL}  browser=chrome  desired_capabilities=${options}

UMA Get Data from Config File
  ${data}=  OperatingSystem.Get File  ${CURDIR}/config.json
  ${json}=  Evaluate  json.loads('''${data}''')  json
  ${URL}=  Get From Dictionary  ${json}  hostname
  ${USER}=  Get From Dictionary  ${json}  username
  ${PWD}=  Get From Dictionary  ${json}  password
  ${CSEC}=  Get From Dictionary  ${json}  client_secret
  ${CID}=  Get From Dictionary  ${json}  client_id
  Set Global Variable  ${URL}
  Set Global Variable  ${USER} 
  Set Global Variable  ${PWD}
  Set Global Variable  ${CSEC} 
  Set Global Variable  ${CID}

LoginService Edit Update Profile

  ${title}=  Get Title
  LoginService Add Person  ${USER_NAME}A  ${FIRST_NAME}A  ${DISPLAY_NAME}A  ${LAST_NAME}A  A${EMAIL}  ${PASSWORD}
  LoginService Delete Person  ${USER_NAME}A

LoginService Delete Person
  [Arguments]  ${user_name}
  Click Element  xpath=//input[@id="PForm:j_idt307"]
  Click Element  xpath=//input[@id="deleteConfirmation:j_idt344"]

LoginService Add Person
  [Arguments]  ${user_name}  ${first_name}  ${display_name}  ${last_name}  ${email}  ${password}
  Click Element  xpath=//a[@href="/identity/person/addPerson.htm"]
  Click Element  xpath=//input[@id="PForm:L:0:IL:0:D:custId_text_"]
  Input Text  xpath=//input[@id="PForm:L:0:IL:0:D:custId_text_"]  ${user_name}
  Click Element  xpath=//input[@id="PForm:L:1:IL:0:D:custId_text_"]
  Input Text  xpath=//input[@id="PForm:L:1:IL:0:D:custId_text_"]  ${first_name}
  Click Element  xpath=//input[@id="PForm:L:2:IL:0:D:custId_text_"]
  Input Text  xpath=//input[@id="PForm:L:2:IL:0:D:custId_text_"]  ${display_name}
  Click Element  xpath=//input[@id="PForm:L:3:IL:0:D:custId_text_"]
  Input Text  xpath=//input[@id="PForm:L:3:IL:0:D:custId_text_"]  ${last_name}
  Click Element  xpath=//input[@id="PForm:L:4:IL:0:D:Email"]
  Input Text  xpath=//input[@id="PForm:L:4:IL:0:D:Email"]  ${email}
  Click Element  xpath=//input[@id="PForm:L:5:IL:0:P:custpasswordId"]
  Input Password  xpath=//input[@id="PForm:L:5:IL:0:P:custpasswordId"]  ${password}
  Click Element  xpath=//input[@id="PForm:L:5:IL:0:j_idt244:custconfirmpasswordId"]
  Input Password  xpath=//input[@id="PForm:L:5:IL:0:j_idt244:custconfirmpasswordId"]  ${password}
  Set Browser Implicit Wait  10
  Click Element  xpath=//input[@id="PForm:L:4:IL:0:D:Email"]
  Click Element  xpath=//button[@name="PForm:j_idt306"]
  Set Browser Implicit Wait  2

LoginService Enter Profile Page
  Title Should Be  Gluu
  Click Element  id=menuPersonal
  Click Element  id=subMenuPersonal
  Set Browser Implicit Wait  2

LoginService Go to Users
  Click Element  xpath=//li[@id="menuUsers"]
  Set Browser Implicit Wait  2
  Click Element  xpath=//li[@id="subMenuLinkUsers2"]
  LoginService Edit Update Profile

LoginService Fill Credentials
  Set Browser Implicit Wait  3
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

UMA Get ID Token Valid
  [Arguments]  ${base_url}  ${well_known}  ${user}  ${pwd}  ${client_id}  ${client_secret}
  ${endpoint}=  UMA Get Token Endpoint  ${well_known}
  Log to Console  El endpoint es ${endpoint}
  ${resp}=  UMA Call Shell ID Token  ${endpoint}  ${client_id}  ${client_secret}
  ${scope}=  Create List  openid  user_name
  ${data}=  Create dictionary  scope=${scope}  grant_type=password  username=admin  password=admin_Abcd1234#  client_id=${client_id}  client_secret=${client_secret}
  ${headers}=  Create Dictionary  cache-control=no-cache
  Log to Console  ${data}
  Create Session  ep  ${base_url}  verify=False
  ${test_uri}=  Set Variable  /oxauth/restv1/token
  ${rosp}=  POST On Session  ep  ${test_uri}  headers=${headers}  json=${data}
  Log to Console  Esto no deberia de estar printeando
  Log to Console  ${rosp}
  ${id_token}=  UMA Get ID Token From Response  ${resp}
  Set Global Variable  ${ID_TOKEN}  ${id_token}
  [Return]  ${id_token}

UMA Call Shell ID Token
  [Arguments]  ${endpoint}  ${client_id}  ${client_secret}
  ${a}=  Run Process  sh  ${CURDIR}${/}id.sh  -t  ${endpoint}  -i  ${client_id}  -p  ${client_secret}
  ${example}=  List Files In Directory  ${CURDIR}
  Log to Console  ${example}
  ${example}=  List Files In Directory  ${CURDIR}/../../../../
  Log to Console  ${example}
  ${n}=  OperatingSystem.Get File  ${CURDIR}/../../../../1.txt
  Log to Console  ${n}
  #OperatingSystem.Remove File  ${CURDIR}${/}1.txt
  [Return]  ${n}

UMA Get Token Endpoint
  [Arguments]  ${well_known} 
  ${headers}=  Create Dictionary  Content-Type  application/json
  Create Session  ep  ${well_known}  verify=False
  ${resp}=  Get Request  ep  /
  ${json}=  Evaluate  json.loads('''${resp.text}''')  json
  ${tk_endpoint}=  Get From Dictionary  ${json}  token_endpoint
  [Return]  ${tk_endpoint}

UMA Get ID Token From Response
  [Arguments]  ${resp}
  ${json}=  Evaluate  json.loads('''${resp}''')  json
  ${id_token}=  Get From Dictionary  ${json}  id_token
  [Return]  ${id_token} 

