//
//  PlacesPresenterTests.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation
import Testing
@testable import Places

@Suite
@MainActor
struct PlacesPresenterTests {
    @Test
    func testLoadPublishesLocations() async {
        // Given a service that returns locations successfully
        let model = makePresenter(result: .success([Location(name: "Paris"), Location(name: "Tokyo")]))
        // When the presenter loads locations
        await model.load()
        // Then it publishes the locations without an error and finishes loading
        #expect((model.locations.compactMap(\.name) == ["Paris", "Tokyo"]))
        #expect(model.errorMessage == nil)
        #expect(!model.isLoading)
    }

    @Test
    func testLoadPublishesErrorOnFailure() async {
        // Given a service that fails to fetch locations
        let model = makePresenter(result: .failure(URLError(.notConnectedToInternet)))
        // When the presenter loads locations
        await model.load()
        // Then it keeps the list empty, publishes an error, and finishes loading
        #expect(model.locations.isEmpty)
        #expect(model.errorMessage != nil)
        #expect(!model.isLoading)
    }

    @Test
    func testFilteredLocationsReturnsAllForEmptySearch() async {
        // Given a loaded list and an empty search query
        let model = makePresenter(result: .success([Location(name: "Paris"), Location(name: "Tokyo")]))
        await model.load()
        // When filtered locations are requested
        // Then all locations are returned
        #expect((model.filteredLocations.count == 2))
    }

    @Test
    func testFilteredLocationsMatchesCaseInsensitively() async {
        // Given locations with different names
        let model = makePresenter(result: .success([Location(name: "Amsterdam"), Location(name: "Mumbai")]))
        await model.load()
        // When searching with mixed letter casing
        model.searchText = "amSTer"
        // Then the matching location is returned
        #expect((model.filteredLocations.compactMap(\.name) == ["Amsterdam"]))
    }

    @Test
    func testFilteredLocationsTrimsSearchWhitespace() async {
        // Given a loaded list of locations
        let model = makePresenter(result: .success([Location(name: "Amsterdam"), Location(name: "Mumbai")]))
        await model.load()
        // When the search query contains surrounding whitespace
        model.searchText = "  Mumbai  "
        // Then whitespace is ignored when matching
        #expect((model.filteredLocations.compactMap(\.name) == ["Mumbai"]))
    }

    @Test
    func testFilteredLocationsReturnsEmptyForNoMatch() async {
        // Given a list that does not contain the searched name
        let model = makePresenter(result: .success([Location(name: "Paris")]))
        await model.load()
        // When searching for a missing location
        model.searchText = "Tokyo"
        // Then no locations are returned
        #expect(model.filteredLocations.isEmpty)
    }

    @Test
    func testDisplayModelUsesNameAndPrecomputesCoordinates() {
        // Given a location with a name and coordinates
        let location = Location(name: "Lisbon", lat: 38.7223, long: -9.1393)
        // When the display model is created
        let displayModel = PlaceDisplayModel(location: location)
        // Then it stores the display name and formatted coordinates
        #expect(displayModel.name == "Lisbon")
        #expect(displayModel.coordinates == "38.7223, -9.1393")
    }

    @Test
    func testDisplayModelUsesLocalizedPlaceholderWhenNameIsMissing() {
        // Given a location without a name
        let location = decodeLocation(#"{ "lat": 37.7748, "long": -122.4194 }"#)
        let placeholder = "Unnamed place"
        // When the display model is created with a placeholder
        let displayModel = PlaceDisplayModel(location: location, unnamedPlaceholder: placeholder)
        // Then the placeholder and formatted coordinates are stored
        #expect(displayModel.name == placeholder)
        #expect(displayModel.coordinates == "37.7748, -122.4194")
    }

    @Test
    func testSelectingLocationBuildsCoordinateDeepLink() throws {
        // Given a location with latitude and longitude
        let model = makePresenter(result: .success([]))
        // When the location is selected
        let url = try #require(model.deepLink(for: decodeLocation("{\"name\":\"San Francisco\",\"lat\":37.7748,\"long\":-122.4194}")))
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        // Then the deep link contains the expected scheme, host, and coordinates
        #expect((components.scheme == "wikipedia-clone"))
        #expect((components.host == "places"))
        #expect((components.queryItems?.first(where: { $0.name == "lat" })?.value == "37.7748"))
        #expect((components.queryItems?.first(where: { $0.name == "lon" })?.value == "-122.4194"))
    }

    @Test
    func testEmptyResponsePublishesEmptyStateError() async {
        // Given a service that returns no locations
        let model = makePresenter(result: .success([]))
        // When the presenter loads locations
        await model.load()
        // Then the list is empty and the empty-state error is published
        #expect(model.locations.isEmpty)
        #expect(model.errorMessage != nil)
    }

    @Test
    func testLoadDoesNotFetchAgainAfterSuccessfulLoad() async {
        // Given a counting service that returns locations
        let service = CountingLocationService(locations: [Location(name: "Paris")])
        let model = PlacesPresenter(interactor: PlacesInteractor(service: service), router: PlacesRouter())
        // When load is called twice
        await model.load()
        await model.load()
        // Then the service is called only once
        #expect((service.callCount == 1))
    }

    private func makePresenter(result: Result<[Location], Error>) -> PlacesPresenter {
        PlacesPresenter(interactor: PlacesInteractor(service: MockLocationService(result: result)), router: PlacesRouter())
    }

    private func decodeLocation(_ json: String) -> Location {
        try! JSONDecoder().decode(Location.self, from: Data(json.utf8))
    }
}

private final class CountingLocationService: LocationFetching {
    private(set) var callCount = 0
    let locations: [Location]

    init(locations: [Location]) { self.locations = locations }

    func fetchLocations() async throws -> [Location] {
        callCount += 1
        return locations
    }
}
