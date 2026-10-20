//
//  CustomLocationPresenter.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation
import Combine

@MainActor
final class CustomLocationPresenter: ObservableObject {
    @Published private(set) var state = CustomLocationViewState()

    private let interactor: any CustomLocationInteracting
    private let router: any CustomLocationRouting
    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?

    init(
        interactor: any CustomLocationInteracting,
        router: any CustomLocationRouting
    ) {
        self.interactor = interactor
        self.router = router

        $state
            .map(\.query)
            .removeDuplicates()
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
            .sink { [weak self] query in
                guard let self else { return }

                guard query.count >= 2 else {
                    searchTask?.cancel()
                    state.suggestions = []
                    state.searchState = .idle
                    return
                }

                searchTask?.cancel()
                searchTask = Task { [weak self] in
                    guard let self else { return }
                    await searchSuggestions(for: query)
                }
            }
            .store(in: &cancellables)
    }

    var trimmedQuery: String {
        state.query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func queryDidChange(_ value: String) {
        state.query = value
        searchTask?.cancel()
        state.suggestions = []
        state.searchState = .idle
        state.resolutionState = .idle
    }

    private func searchSuggestions(for query: String) async {
        state.searchState = .searching

        do {
            let results = try await interactor.searchSuggestions(for: query)
            try Task.checkCancellation()

            state.suggestions = results
            state.searchState = results.isEmpty ? .noResults : .results
        } catch is CancellationError {
            return
        } catch {
            guard !Task.isCancelled else { return }
            state.suggestions = []
            state.searchState = .failed
        }
    }

    func selectSuggestion(_ suggestion: String) async -> URL? {
        state.query = suggestion
        searchTask?.cancel()
        state.resolutionState = .idle
        return await resolvePlace(named: suggestion)
    }

    func submitQuery() async -> URL? {
        guard !trimmedQuery.isEmpty else { return nil }
        searchTask?.cancel()
        state.resolutionState = .idle
        return await resolvePlace(named: trimmedQuery)
    }

    func latitudeDidChange(_ value: String) {
        state.latitude = value
        state.coordinateError = nil
    }

    func longitudeDidChange(_ value: String) {
        state.longitude = value
        state.coordinateError = nil
    }

    func submitCoordinates() -> URL? {
        guard
            let latitudeValue = Double(state.latitude.trimmingCharacters(in: .whitespacesAndNewlines)),
            let longitudeValue = Double(state.longitude.trimmingCharacters(in: .whitespacesAndNewlines)),
            (-90...90).contains(latitudeValue),
            (-180...180).contains(longitudeValue)
        else {
            state.coordinateError = NSLocalizedString(
                "custom_location.coordinates.invalid",
                comment: ""
            )
            return nil
        }

        return router.coordinateDeepLink(
            latitude: latitudeValue,
            longitude: longitudeValue
        )
    }

    func resolvePlace(named value: String) async -> URL? {
        let placeName = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !placeName.isEmpty else { return nil }

        state.resolutionState = .resolving
        defer {
            if case .resolving = state.resolutionState {
                state.resolutionState = .idle
            }
        }

        do {
            let place = try await interactor.resolvePlace(named: placeName)
            try Task.checkCancellation()

            return router.coordinateDeepLink(
                latitude: place.lat,
                longitude: place.long
            )
        } catch is CancellationError {
            return nil
        } catch {
            state.resolutionState = .failed(
                message: NSLocalizedString(
                    "custom_location.search.place_not_found",
                    comment: ""
                )
            )
            return nil
        }
    }

    func openMapCoordinates(latitude: Double, longitude: Double) -> URL? {
        router.coordinateDeepLink(latitude: latitude, longitude: longitude)
    }
}
