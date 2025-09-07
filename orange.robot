*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Browser To Login Page
Suite Teardown    Close All Browsers
Test Teardown    Go To Login Page

*** Variables ***
${BASE_URL}    https://opensource-demo.orangehrmlive.com/
${BROWSER}     Chrome

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    name=username    10s

Go To Login Page
    ${logout_visible}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//p[@class='oxd-userdropdown-name']    3s
    IF    ${logout_visible}
        Click Element    xpath=//p[@class='oxd-userdropdown-name']
        Click Element    xpath=//a[text()='Logout']
    END
    Go To    ${BASE_URL}
    Wait Until Element Is Visible    name=username    10s

*** Test Cases ***
Login With Valid Credentials
    Input Text    name=username    Admin
    Input Text    name=password    admin123
    Click Button    xpath=//button[@type='submit']
    Wait Until Page Contains    Dashboard    10s

Login With Invalid Credentials
    Input Text    name=username    wrong_user
    Input Text    name=password    wrong_pass
    Click Button    xpath=//button[@type='submit']
    Wait Until Page Contains    Invalid credentials    10s

Login With Empty Credentials
    Click Button    xpath=//button[@type='submit']
    Wait Until Page Contains    Required    10s
