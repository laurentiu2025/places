//
//  PlacesPresenter.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation
import CoreLocation

@MainActor
final class PlacesPresenter: ObservableObject {
    @Published private(set) var locations: [Location] = []
    @Published private(set) var displayLocations: [PlaceDisplayModel] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var searchText = ""

    private let interactor: any PlacesInteracting
    private let router: any PlacesRouting
    private var didLoad = false

    init(interactor: any PlacesInteracting, router: any PlacesRouting) {
        self.interactor = interactor
        self.router = router
    }

    var filteredLocations: [PlaceDisplayModel] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return displayLocations }
        return displayLocations.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }

    func load() async {
        guard !isLoading, !didLoad else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            locations = try await interactor.fetchLocations()
            displayLocations = locations.map { PlaceDisplayModel(location: $0) }
            didLoad = true
            if locations.isEmpty { errorMessage = NSLocalizedString("places.error.no_locations", comment: "") }
        } catch {
            errorMessage = NSLocalizedString("places.error.load_failed", comment: "")
        }
    }

    func deepLink(for location: Location) -> URL? {
        router.coordinateDeepLink(latitude: location.lat, longitude: location.long)
    }
}
