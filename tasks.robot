*** Settings ***
Documentation    Testing Assignment 2
Library    SeleniumLibrary
# "Given that the user is on the IMDb homepage"
Test Setup    Open Browser    https://www.imdb.com/   firefox
Test Teardown    Close Browser

*** Variables ***
${SEARCH_QUERY}    The Shawshank Redemption
${TOP_RATED_MOVIE}    The Shawshank Redemption

*** Tasks ***
Verify user can search for a movie on the IMDb homepage
    When user enters ${SEARCH_QUERY} in the search bar
    And user clicks the search button
    Then user should directed to the results page
    And results page header should contain ${SEARCH_QUERY}
    And first search result should contain ${SEARCH_QUERY}

Verify user can access the top-rated movies section
    When user clicks on menu
    And user clicks on "Top 250 Movies" span
    Then user should be directed to the Top 250 Movies movies section page
    And page should display a list of the Top 250 Movies
    And first movie in the list should be ${TOP_RATED_MOVIE}

Verify user can search for movies released in a specific year on IMDb
    When user clicks on "All" span
    And user clicks on "Advanced Search" span
    And user clicks on "Advanced Title Search" link

*** Keywords ***
User enters ${search_query} in the search bar
    Input Text    id=suggestion-search    ${search_query}

User clicks the search button
    Click Button    id=suggestion-search-button

WebElement ${locator} text should contain ${text}
    ${web_element}=    Get WebElement    ${locator}
    ${actual_text}=    Get Text    ${web_element}
    Should Contain    ${actual_text}    ${text}    ignore_case=True

User should directed to the results page
    Title Should Be    Find - IMDb

Results page header should contain ${header_text}
    WebElement tag=h1 text should contain ${header_text}

First search result should contain ${text}
    WebElement class:ipc-metadata-list-summary-item__t text should contain ${text}

User clicks on menu
    Click Element    id:imdbHeader-navDrawerOpen

Click on ${element} with text ${text}
    Click Element    xpath://${element}\[text()=${text}]

User should be directed to the Top 250 Movies movies section page
    Title Should Be    Top 250 Movies - IMDb

Page should display a list of the Top 250 Movies
    Page Should Contain    IMDb Top 250 Movies
    Page Should Contain Element    class:lister

First movie in the list should be ${text}
    WebElement xpath://table/tbody/tr[1]/td[@class="titleColumn"]/a text should contain ${text}

User clicks on ${text} span
    Click on span with text ${text}

User clicks on ${text} link
    Click on a with text ${text}
