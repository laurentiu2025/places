//
//  CustomLocationPresenterTests.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation
import Testing
@testable import Places

@Suite
@MainActor
struct CustomLocationPresenterTests {
    @Test
    func queryChangeClearsPreviousResultsAndReturnsToIdle() async {
        // Given a presenter that returns an Amsterdam suggestion
        let presenter = makePresenter(searchResult: .success(["Amsterdam"]))
        // When the query is entered and the search completes
        presenter.queryDidChange("Amsterdam")
        try? await Task.sleep(nanoseconds: 450_000_000)
        // Then the suggestion is published as results
        #expect(presenter.state.suggestions == ["Amsterdam"])
        #expect(presenter.state.searchState == .results)

        // When the query changes to a shorter value
        presenter.queryDidChange("A")
        #expect(presenter.state.query == "A")
        #expect(presenter.state.suggestions.isEmpty)
        // Then previous suggestions are cleared and search returns to idle
        #expect(presenter.state.searchState == .idle)
    }

    @Test
    func searchWithNoResultsPublishesNoResultsState() async {
        // Given a presenter whose search returns no suggestions
        let presenter = makePresenter(searchResult: .success([]))
        // When a query with no matches is searched
        presenter.queryDidChange("Atlantis")
        try? await Task.sleep(nanoseconds: 450_000_000)
        // Then the state indicates no results and the suggestions are empty
        #expect(presenter.state.searchState == .noResults)
        #expect(presenter.state.suggestions.isEmpty)
    }

    @Test
    func searchFailurePublishesFailedState() async {
        // Given a presenter whose search fails
        let presenter = makePresenter(searchResult: .failure(TestError.failed))
        // When a query is searched
        presenter.queryDidChange("Amsterdam")
        try? await Task.sleep(nanoseconds: 450_000_000)
        // Then the state indicates failure and no suggestions are published
        #expect(presenter.state.searchState == .failed)
        #expect(presenter.state.suggestions.isEmpty)
    }

    @Test
    func coordinateSubmissionRejectsInvalidLatitude() {
        // Given a presenter with a latitude outside the valid range
        let presenter = makePresenter()
        // When coordinates are submitted
        presenter.latitudeDidChange("90.1")
        presenter.longitudeDidChange("4.9")
        // Then submission is rejected with a validation error
        #expect(presenter.submitCoordinates() == nil)
        #expect(presenter.state.coordinateError != nil)
    }

    @Test
    func coordinateSubmissionRejectsNonNumericInput() {
        // Given a presenter with non-numeric latitude input
        let presenter = makePresenter()
        // When coordinates are submitted
        presenter.latitudeDidChange("north")
        presenter.longitudeDidChange("4.9")
        // Then submission is rejected with a validation error
        #expect(presenter.submitCoordinates() == nil)
        #expect(presenter.state.coordinateError != nil)
    }

    @Test
    func coordinateSubmissionAcceptsBoundaryCoordinates() throws {
        // Given a presenter with the maximum valid latitude and longitude
        let presenter = makePresenter()
        // When the coordinates are submitted
        presenter.latitudeDidChange("90")
        presenter.longitudeDidChange("180")
        let url = try #require(presenter.submitCoordinates())
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        // Then a deep link contains the submitted coordinates and no validation error remains
        #expect(components.queryItems?.first(where: { $0.name == "lat" })?.value == "90.0")
        #expect(components.queryItems?.first(where: { $0.name == "lon" })?.value == "180.0")
        #expect(presenter.state.coordinateError == nil)
    }

    @Test
    func blankQueryDoesNotResolvePlace() async {
        // Given a presenter with a blank query
        let presenter = makePresenter(resolveResult: .success(Location(name: "Amsterdam", lat: 52.3676, long: 4.9041)))
        // When the query is submitted
        let url = await presenter.submitQuery()
        // Then no resolution is attempted
        #expect(url == nil)
        #expect(presenter.state.resolutionState == .idle)
    }

    @Test
    func selectingSuggestionBuildsCoordinateDeepLink() async throws {
        // Given a presenter that can resolve Amsterdam
        let presenter = makePresenter(resolveResult: .success(Location(name: "Amsterdam", lat: 52.3676, long: 4.9041)))
        // When the Amsterdam suggestion is selected
        let url = try #require(await presenter.selectSuggestion("Amsterdam"))
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        // Then a coordinate deep link is returned and resolution finishes
        #expect(components.host == "places")
        #expect(components.queryItems?.first(where: { $0.name == "lat" })?.value == "52.3676")
        #expect(presenter.state.resolutionState == .idle)
    }

    @Test
    func failedPlaceResolutionPublishesErrorState() async {
        // Given a presenter whose place resolution fails
        let presenter = makePresenter(resolveResult: .failure(TestError.failed))
        // When an unknown place is resolved
        let url = await presenter.resolvePlace(named: "Unknown Place")
        // Then no URL is returned and the resolution state contains an error message
        #expect(url == nil)
        if case .failed(let message) = presenter.state.resolutionState {
            #expect(!message.isEmpty)
        } else {
            Issue.record("Expected place resolution to fail")
        }
    }

    private func makePresenter(
        searchResult: Result<[String], Error> = .success([]),
        resolveResult: Result<Location, Error> = .success(Location(name: "Amsterdam", lat: 52.3676, long: 4.9041))
    ) -> CustomLocationPresenter {
        let interactor = TestCustomLocationInteractor(searchResult: searchResult, resolveResult: resolveResult)
        return CustomLocationPresenter(interactor: interactor, router: CustomLocationRouter())
    }
}

private enum TestError: Error {
    case failed
}

private struct TestCustomLocationInteractor: CustomLocationInteracting {
    let searchResult: Result<[String], Error>
    let resolveResult: Result<Location, Error>

    func searchSuggestions(for query: String) async throws -> [String] {
        try searchResult.get()
    }

    func resolvePlace(named name: String) async throws -> Location {
        try resolveResult.get()
    }
}
