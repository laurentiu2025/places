//
//  CustomLocationViewState.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

struct CustomLocationViewState {
    var query = ""
    var suggestions: [String] = []
    var searchState: PlaceSearchState = .idle

    var latitude = ""
    var longitude = ""
    var coordinateError: String?
    var resolutionState: PlaceResolutionState = .idle
}

enum PlaceSearchState: Equatable {
    case idle
    case searching
    case results
    case noResults
    case failed
}

enum PlaceResolutionState: Equatable {
    case idle
    case resolving
    case failed(message: String)
}
