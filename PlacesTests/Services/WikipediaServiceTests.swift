//
//  WikipediaServiceTests.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Testing
@testable import Places

@Suite
struct WikipediaServiceTests {
    @Test
    func testArticleURLBuildsWikipediaURL() throws {
        // Given a valid article title
        // When the article URL is requested
        let url = try #require(WikipediaService().articleURL(for: "New York City"))
        // Then the URL is valid for the expected title
        #expect((url.scheme == "https"))
        #expect((url.host == "en.wikipedia.org"))
        #expect(url.path.hasSuffix("New_York_City"))
    }
    @Test
    func testArticleURLTrimsWhitespace() throws {
        // Given a title surrounded by whitespace
        // When the article URL is requested
        let url = try #require(WikipediaService().articleURL(for: "  Paris  "))
        // Then the URL is valid for the expected title
        #expect(url.absoluteString.hasSuffix("/Paris"))
    }
    @Test
    func testArticleURLRejectsEmptyInput() {
        // Given an empty title
        // When the article URL is requested
        // Then no URL is returned
        #expect(WikipediaService().articleURL(for: "  \n") == nil)
    }
    @Test
    func testArticleURLRejectsTabsOnly() {
        // Given a title containing only tabs and whitespace
        // When the article URL is requested
        // Then no URL is returned
        #expect(WikipediaService().articleURL(for: "\t\n  ") == nil)
    }
    @Test
    func testArticleURLPreservesAccentedCharacters() throws {
        // Given a title containing accented characters
        // When the article URL is requested
        let url = try #require(WikipediaService().articleURL(for: "São Paulo"))
        // Then the URL is valid for the expected title
        #expect((url.host == "en.wikipedia.org"))
        #expect(url.absoluteString.contains("S%C3%A3o") || url.absoluteString.contains("São"))
    }
    @Test
    func testArticleURLReplacesSpacesWithUnderscores() throws {
        // Given a multi-word title
        // When the article URL is requested
        let url = try #require(WikipediaService().articleURL(for: "Cape Town"))
        // Then the URL is valid for the expected title
        #expect(url.path.hasSuffix("Cape_Town"))
    }
    @Test
    func testSearchSuggestionsReturnsEmptyForShortQuery() async throws {
        // Given queries shorter than the minimum search length
        // When search suggestions are requested
        let oneCharacterResults = try await WikipediaService().searchSuggestions(for: "a")
        let whitespaceResults = try await WikipediaService().searchSuggestions(for: "  ")
        // Then no suggestions are returned
        #expect((oneCharacterResults == []))
        #expect((whitespaceResults == []))
    }
}
