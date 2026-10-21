*** Settings ***
Library          SeleniumLibrary
Library          DataDriver    file=date_test_S1.csv    dialect=excel
Suite Setup      Deschide Aplicatia Si Autentificare
Suite Teardown   Close Browser
Test Template    Ruleaza Scenariu Replicare USERS

*** Variables ***
${URL}           http://localhost:8080/
${BROWSER}       chrome

*** Test Cases ***
Testare Automatizata USERS Monolit pentru ${id_user} cu status ${expected_status}    ${id_user}    ${email_user}    ${expected_status}

*** Keywords ***
Deschide Aplicatia Si Autentificare
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    id:username    timeout=5s
    Input Text      id:username    admin@test.com
    Input Text      id:password    password123
    Click Button    id:loginBtn
    Wait Until Element Is Visible    id:addBtn    timeout=5s

Ruleaza Scenariu Replicare USERS
    [Arguments]    ${id_user}    ${email_user}    ${expected_status}

    Wait Until Element Is Visible    id:subscription_id    timeout=5s

    Clear Element Text    id:subscription_id
    Clear Element Text    id:service_name
    Clear Element Text    id:price
    Clear Element Text    id:user_email

    Input Text      id:service_name       ReplicationService
    Input Text      id:price              10.00
    Select From List By Value    id:billing_cycle    monthly

    IF    '${expected_status}' == 'valid'
        Input Text      id:user_email         admin@test.com
    ELSE
        IF    '${email_user}' != 'EMPTY' and '${email_user}' != ''
            Input Text    id:user_email    ${email_user}
        END
    END

    IF    '${id_user}' != 'EMPTY' and '${id_user}' != ''
        Input Text    id:subscription_id    ${id_user}
    END

    Click Button    id:addBtn

    IF    '${expected_status}' == 'valid'
        Element Should Not Be Visible    id:dbAlert
    ELSE IF    '${expected_status}' == 'invalid_primary_key' or '${expected_status}' == 'invalid_unique_email'
        Wait Until Element Is Visible    id:dbAlert    timeout=4s
    ELSE IF    '${expected_status}' == 'invalid_frontend'
        Log    Interfata HTML5 blocheaza trimiterea formularului, deci starea id:dbAlert nu ne intereseaza aici.
    END

    Sleep    1s