//
//  PlacesInteractor.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

struct PlacesInteractor: PlacesInteracting {
    let service: any LocationFetching

    func fetchLocations() async throws -> [Location] {
        try await service.fetchLocations()
    }
}
