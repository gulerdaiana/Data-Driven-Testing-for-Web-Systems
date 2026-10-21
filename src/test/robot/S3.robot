*** Settings ***
Library          SeleniumLibrary
Library          DataDriver    file=date_test_S3.csv    dialect=excel    test_case_names=\${id}_\${expected_status}
Suite Teardown   Close All Browsers
Test Template    Ruleaza Scenariu Race Condition

*** Variables ***
${URL}           http://localhost:8080/
${BROWSER}       chrome

*** Test Cases ***
Testare Automatizata Concurenta Monolit    ${id}    ${email}    ${service}    ${price}    ${cycle}    ${expected_status}

*** Keywords ***
Deschide Sesiune Si Autentificare
    [Arguments]    ${browser_alias}
    Open Browser    ${URL}    ${BROWSER}    alias=${browser_alias}
    Maximize Browser Window
    Wait Until Element Is Visible    id:username    timeout=5s
    Input Text      id:username    admin@test.com
    Input Text      id:password    password123
    Click Button    id:loginBtn
    Wait Until Element Is Visible    id:addBtn    timeout=5s

Completeaza Formular Abonament
    [Arguments]    ${id}    ${email}    ${service}    ${price}    ${cycle}
    Wait Until Element Is Visible    id:subscription_id    timeout=5s
    Input Text      id:service_name       ${service}
    Input Text      id:price              ${price}
    Select From List By Value    id:billing_cycle    ${cycle}
    Input Text      id:user_email         ${email}
    Input Text      id:subscription_id    ${id}

Ruleaza Scenariu Race Condition
    [Arguments]    ${id}    ${email}    ${service}    ${price}    ${cycle}    ${expected_status}

    Deschide Sesiune Si Autentificare    Browser_A
    Completeaza Formular Abonament       ${id}    ${email}    ${service}    ${price}    ${cycle}

    Deschide Sesiune Si Autentificare    Browser_B
    Completeaza Formular Abonament       ${id}    ${email}    ${service}    ${price}    ${cycle}

    Switch Browser    Browser_A
    Click Button      id:addBtn

    Switch Browser    Browser_B
    Click Button      id:addBtn

    Wait Until Element Is Visible    id:dbAlert    timeout=5s

    Close All Browsers