//
//  MapKitPlaceResolver.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation
import MapKit
import CoreLocation

enum PlaceResolutionError: Error {
    case emptyQuery
    case noResults
}

struct MapKitPlaceResolver: PlaceResolving {
    func resolvePlace(named name: String) async throws -> Location {
        let query = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            throw PlaceResolutionError.emptyQuery
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = [.address, .pointOfInterest]

        do {
            let response = try await MKLocalSearch(request: request).start()

            if let item = response.mapItems.first {
                let coordinate = item.placemark.coordinate
                return Location(
                    name: item.name ?? query,
                    lat: coordinate.latitude,
                    long: coordinate.longitude
                )
            }
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            // MapKit search failed; try geocoding as a fallback.
        }

        let placemarks = try await CLGeocoder().geocodeAddressString(query)

        guard let coordinate = placemarks.first?.location?.coordinate else {
            throw PlaceResolutionError.noResults
        }

        return Location(
            name: query,
            lat: coordinate.latitude,
            long: coordinate.longitude
        )
    }
}
