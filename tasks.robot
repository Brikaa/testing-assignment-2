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
    When user clicks on All search option
    And user clicks on "Advanced Search" span
    Then user should be directed to page containing "Advanced Title Search" link
    When user clicks on "Advanced Title Search" link
    And user selects "Feature Film" as title type
    And user selects the "Action" genre from Genres

*** Keywords ***
User enters ${search_query} in the search bar
    Input Text    id=suggestion-search    ${search_query}

User clicks the search button
    Click Button    id=suggestion-search-button

WebElement ${locator} text should contain ${text}
    ${actual_text}=    Get Text    ${locator}
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

User clicks on All search option
    Click Element    xpath://span[@class="ipc-btn__text" and text()="All"]

User should be directed to page containing ${text} link
    Page Should Contain Element    xpath://a[text()=${text}]

Click on input with name ${name} and value ${value}
    Click Element    xpath://input[@name=${name} and @value=${value}]

User selects "Feature Film" as title type
    Click on input with name "title_type" and value "feature"

User selects the "Action" genre from Genres
    Click on input with name "genres" and value "action"
