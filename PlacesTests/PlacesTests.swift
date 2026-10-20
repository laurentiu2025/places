//
//  PlacesTests.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation
import Testing
@testable import Places

@Suite
struct PlacesTests {
    @Test
    func locationIdentifierUsesCoordinates() {
        let location = Location(name: "Amsterdam", lat: 52.3676, long: 4.9041)
        #expect(location.id == "52.3676,4.9041")
    }

    @Test
    func locationDecodesMissingName() throws {
        let json = Data("{\"lat\":37.7748,\"long\":-122.4194}".utf8)
        let location = try JSONDecoder().decode(Location.self, from: json)
        #expect(location.name == nil)
        #expect(location.lat == 37.7748)
        #expect(location.long == -122.4194)
    }

    @Test
    func displayModelTrimsBlankNameAndUsesPlaceholder() {
        let location = Location(name: "   ", lat: 1.23456, long: -2.34567)
        let model = PlaceDisplayModel(location: location, unnamedPlaceholder: "Unnamed")
        #expect(model.name == "Unnamed")
        #expect(model.isUnnamed)
        #expect(model.coordinates == "1.2346, -2.3457")
    }

    @Test
    func displayModelPreservesNonBlankName() {
        let model = PlaceDisplayModel(location: Location(name: "  Paris  ", lat: 48.8566, long: 2.3522))
        #expect(model.name == "  Paris  ")
        #expect(!model.isUnnamed)
    }

    @Test
    func deepLinkBuilderIncludesBothCoordinates() throws {
        let url = try #require(CoordinateDeepLinkBuilder.makeURL(latitude: 52.3676, longitude: 4.9041))
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect(components.scheme == "wikipedia-clone")
        #expect(components.host == "places")
        #expect(components.queryItems?.first(where: { $0.name == "lat" })?.value == "52.3676")
        #expect(components.queryItems?.first(where: { $0.name == "lon" })?.value == "4.9041")
    }

    @Test
    func deepLinkBuilderSupportsCoordinateBoundaries() throws {
        for (latitude, longitude) in [(-90.0, -180.0), (0.0, 0.0), (90.0, 180.0)] {
            let url = try #require(CoordinateDeepLinkBuilder.makeURL(latitude: latitude, longitude: longitude))
            #expect(url.scheme == "wikipedia-clone")
        }
    }
}
