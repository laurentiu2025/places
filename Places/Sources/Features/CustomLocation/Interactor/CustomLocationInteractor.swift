//
//  CustomLocationInteractor.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation

struct CustomLocationInteractor: CustomLocationInteracting {
    private let wikipediaService: any WikipediaServicing
    private let placeResolver: any PlaceResolving

    init(
        wikipediaService: any WikipediaServicing = WikipediaService(),
        placeResolver: any PlaceResolving = MapKitPlaceResolver()
    ) {
        self.wikipediaService = wikipediaService
        self.placeResolver = placeResolver
    }

    func searchSuggestions(for query: String) async throws -> [String] {
        try await wikipediaService.searchSuggestions(for: query)
    }

    func resolvePlace(named name: String) async throws -> Location {
        try await placeResolver.resolvePlace(named: name)
    }
}
