*** Settings ***
Documentation    Testing Assignment 2
Library    SeleniumLibrary
# "Given that the user is on the IMDb homepage"
Test Setup    Open Browser    https://www.imdb.com/   firefox
Test Teardown    Close Browser

*** Variables ***
${SEARCH_QUERY}    The Shawshank Redemption

*** Tasks ***
Verify user can search for a movie on the IMDb homepage
    When user enters ${SEARCH_QUERY}
    And user clicks search button
    Then user should be on results page
    And results page header should contain ${SEARCH_QUERY}
    And first search result should contain ${SEARCH_QUERY}

*** Keywords ***
User enters ${search_query}
    Input Text    id=suggestion-search    ${search_query}

User clicks search button
    Click Button    id=suggestion-search-button

WebElement ${locator} text should contain ${text}
    ${web_element}=    Get WebElement    ${locator}
    ${actual_text}=    Get Text    ${web_element}
    Should Contain    ${actual_text}    ${text}    ignore_case=True

User should be on results page
    ${title}=    Get Title
    Should Contain    ${title}    Find    ignore_case=True

Results page header should contain ${header_text}
    WebElement tag=h1 text should contain ${header_text}

First search result should contain ${text}
    WebElement class=ipc-metadata-list-summary-item__t text should contain ${text}
