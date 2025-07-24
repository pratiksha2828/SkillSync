*** Settings ***
Library           SeleniumLibrary
Library           DataDriver  file=SkillSync_Test_Cases.xlsx  sheet_name=LoginData
Test Template     Login Test

*** Test Cases ***
Login with ${username}

*** Keywords ***
Login Test
    [Arguments]    ${username}    ${password}
    Open Browser    https://example.com/login    chrome
    Input Text      id=username_field    ${username}
    Input Text      id=password_field    ${password}
    Click Button    id=login_button
    Page Should Contain    Welcome
    Close Browser
