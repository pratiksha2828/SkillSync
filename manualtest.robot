*** Settings ***
Library    MyKeywords.py

*** Test Cases ***
Manual Call
    execute_test_case    User Management    TC_UM_01    login with valid credentials    valid username and password    user is logged in and redirected to dashboard
