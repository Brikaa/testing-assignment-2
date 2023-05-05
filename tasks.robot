*** Settings ***
Documentation    Testing Assignment 2
Library    SeleniumLibrary
Suite Setup    Open Browser    https://www.imdb.com/   firefox
Suite Teardown    Close Browser

*** Tasks ***
Scenario1
    Input Into Searchbar    The Shawshank Redemption
    Sleep    3

*** Keywords ***
Input Into Searchbar
    [Arguments]    ${query}
    Input Text    id=suggestion-search    ${query}
