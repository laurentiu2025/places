//
//  LocationFetching.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

protocol LocationFetching {
    func fetchLocations() async throws -> [Location]
}
