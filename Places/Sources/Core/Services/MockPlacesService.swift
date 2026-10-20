//
//  MockPlacesService.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation

struct MockPlacesService: LocationFetching {
    func fetchLocations() async throws -> [Location] {
        [
            Location(name: "UI Test Amsterdam"),
            Location(name: "UI Test Copenhagen"),
            Location(name: "UI Test Mumbai")
        ]
    }
}
