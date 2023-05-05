*** Settings ***
Documentation    Testing Assignment 2
Library    SeleniumLibrary
Library    String
Library    Collections
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
    And user enters a start year and end year in the "Release Date" fields (2010 - 2020)
    And User clicks on search button in advanced search
    Sleep    2    # For some reason, "User Rating" link does not work instantly
    And user clicks on "User Rating" link
    Then all movies displayed in the search results page should be Action movies
    And all movies displayed in the search results page should be released between ${2010} and ${2020}
    And all movies displayed in the search results page should be sorted by User Rating

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

Enter ${value} in input with name ${name}
    Input Text    xpath://input[@name=${name}]    ${value}

User enters a start year and end year in the "Release Date" fields (${start_year} - ${end_year})
    Enter 2010 in input with name "release_date-min"
    Enter 2020 in input with name "release_date-max"

User clicks on search button in advanced search
    Click Button    xpath://button[@type="submit" and text()="Search"]

All ${elements} are ${genre}
    # Get text
    # Remove spaces
    # Split text by ,
    # Check if genre in splitted text
    FOR    ${element}    IN    @{elements}
        ${text}=    Get Text    ${element}
        ${text_no_spaces}=    Replace String    ${text}    ${SPACE}    ${EMPTY}
        @{genre_list}=    Split String    ${text_no_spaces}    ,
        List Should Contain Value    ${genre_list}    ${genre}
    END

All movies displayed in the search results page should be ${genre} movies
    @{elements}=    Get WebElements    //div[contains(@class, "lister-item")]//span[@class="genre"]
    All ${elements} are ${genre}

All ${elements} are between ${start_year} and ${end_year}
    # Get text
    # Remove ( and )
    # To int
    # Check if >= start_year, <= end_year
    FOR    ${element}    IN    @{elements}
        ${text}=    Get Text    ${element}
        ${year_str}=    Replace String Using Regexp    ${text}    [^0-9]    ${EMPTY}
        ${year}=    Convert To Integer    ${year_str}
        IF    ${year} < ${start_year} or ${year} > ${end_year}
            Fail
        END
    END

All movies displayed in the search results page should be released between ${start_year} and ${end_year}
    @{elements}=    Get WebElements    class:lister-item-year
    All ${elements} are between ${start_year} and ${end_year}

Filter And Convert To Number
    [Arguments]    ${element}
    ${text}=    Get Text    ${element}
    ${filtered}=    Replace String Using Regexp    ${text}    [^0-9.]    ${EMPTY}
    ${float}=    Convert To Number    ${filtered}
    RETURN    ${float}


${elements} are sorted descendingly
    # Check if elements[i] >= elements[i+1]
    ${length}=    Get Length    ${elements}
    FOR    ${i}    IN RANGE    ${length - 1}
        ${first}=    Filter And Convert To Number    ${elements}[${i}]
        ${second}=    Filter And Convert To Number    ${elements}[${i + 1}]
        IF    ${first} < ${second}
            Fail
        END
    END


All movies displayed in the search results page should be sorted by User Rating
    @{elements}=    Get WebElements    class:ratings-imdb-rating
    ${elements} are sorted descendingly
