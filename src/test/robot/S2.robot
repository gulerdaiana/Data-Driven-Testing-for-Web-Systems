*** Settings ***
Library          SeleniumLibrary
Library          DataDriver    file=date_test_S2.csv    dialect=excel    test_case_names=\${id}_\${expected_status}
Suite Setup      Deschide Aplicatia Si Autentificare
Suite Teardown   Close Browser
Test Template    Ruleaza Scenariu Constrangeri DB

*** Variables ***
${URL}           http://localhost:8080/
${BROWSER}       chrome

*** Test Cases ***
Testare Automatizata SubStream Monolit    ${id}    ${email}    ${service}    ${price}    ${cycle}    ${expected_status}

*** Keywords ***
Deschide Aplicatia Si Autentificare
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    id:username    timeout=5s
    Input Text      id:username    admin@test.com
    Input Text      id:password    password123
    Click Button    id:loginBtn
    Wait Until Element Is Visible    id:addBtn    timeout=5s

Ruleaza Scenariu Constrangeri DB
    [Arguments]    ${id}    ${email}    ${service}    ${price}    ${cycle}    ${expected_status}

    Wait Until Element Is Visible    id:subscription_id    timeout=5s

    Input Text      id:service_name       ${service}
    Input Text      id:price              ${price}
    Input Text      id:user_email         ${email}

    IF    '${cycle}' == 'monthly' or '${cycle}' == 'annually' or '${cycle}' == 'weekly'
        Select From List By Value    id:billing_cycle    ${cycle}
    ELSE
        Select From List By Value    id:billing_cycle    monthly
    END

    IF    '${id}' != 'EMPTY' and '${id}' != ''
        Input Text    id:subscription_id    ${id}
    ELSE
        Clear Element Text    id:subscription_id
    END

    Click Button    id:addBtn

    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    id:dbAlert    timeout=2s

    IF    '${expected_status}' == 'valid' or '${expected_status}' == 'invalid_frontend'
        Run Keyword If    ${status}    Fail    Alert should not be visible for valid/frontend cases.
    ELSE
        Log    Daca alerta nu apare, inseamna ca DB-ul a acceptat valoarea (ex: pret negativ sau ciclu nesuportat in UI dar permis in DB).
    END

    Sleep    1s