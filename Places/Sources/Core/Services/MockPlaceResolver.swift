//
//  MockPlaceResolver.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation

struct MockPlaceResolver: PlaceResolving {
    func resolvePlace(named name: String) async throws -> Location {
        let query = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { throw PlaceResolutionError.emptyQuery }

        switch query.lowercased() {
        case let value where value.contains("copenhagen"):
            return Location(name: query, lat: 55.6761, long: 12.5683)
        case let value where value.contains("mumbai"):
            return Location(name: query, lat: 19.0760, long: 72.8777)
        case let value where value.contains("san francisco"):
            return Location(name: query, lat: 37.7748, long: -122.4194)
        default:
            return Location(name: query, lat: 52.3676, long: 4.9041)
        }
    }
}
