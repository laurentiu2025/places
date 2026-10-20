//
//  PlacesInteracting.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

protocol PlacesInteracting {
    func fetchLocations() async throws -> [Location]
}
