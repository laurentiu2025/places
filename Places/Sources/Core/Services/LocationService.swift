//
//  LocationService.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation

struct LocationService: LocationFetching {
    static let endpoint = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!
    private let session: URLSession

    init(session: URLSession = .shared) { self.session = session }

    func fetchLocations() async throws -> [Location] {
        let (data, response) = try await session.data(from: Self.endpoint)
        guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        if let wrapped = try? decoder.decode(LocationsResponse.self, from: data) { return wrapped.locations }
        if let array = try? decoder.decode([Location].self, from: data) { return array }
        throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unexpected locations JSON format."))
    }
}
