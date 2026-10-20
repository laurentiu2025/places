//
//  PlacesListView.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import SwiftUI

struct PlacesListView: View {
    @StateObject private var presenter: PlacesPresenter
    @Environment(\.openURL) private var openURL
    @State private var showingCustomLocation = false

    init(presenter: PlacesPresenter? = nil) {
        _presenter = StateObject(wrappedValue: presenter ?? PlacesAssembly.makePresenter())
    }

    var body: some View {
        navigationContent()
    }

    @ViewBuilder
    private func navigationContent() -> some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            NavigationStack {
                mainContent()
                    .navigationTitle(NSLocalizedString("places.title", comment: ""))
                    .searchable(
                        text: $presenter.searchText,
                        prompt: NSLocalizedString("places.search.prompt", comment: "")
                    )
                    .accessibilityIdentifier("places-search-field")
                    .toolbar {
                        searchToolbarItem()
                    }
                    .task {
                        await presenter.load()
                    }
                    .fullScreenCover(isPresented: $showingCustomLocation) {
                        CustomLocationSheet()
                            .background(Color(uiColor: .systemBackground).ignoresSafeArea())
                    }
            }
        }
        .toolbarBackground(Color(uiColor: .systemBackground), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    @ViewBuilder
    private func mainContent() -> some View {
        Group {
            if presenter.isLoading && presenter.locations.isEmpty {
                loadingState()
            } else if let error = presenter.errorMessage, presenter.locations.isEmpty {
                errorState(message: error)
            } else if presenter.filteredLocations.isEmpty {
                emptyState()
            } else {
                locationsList()
            }
        }
    }

    @ViewBuilder
    private func loadingState() -> some View {
        LoadingStateView(title: NSLocalizedString("places.loading", comment: ""))
    }

    @ViewBuilder
    private func errorState(message: String) -> some View {
        ErrorStateView(
            message: message,
            actionTitle: NSLocalizedString("common.try_again", comment: "")
        ) {
            Task { await presenter.load() }
        }
    }

    @ViewBuilder
    private func emptyState() -> some View {
        EmptyStateView(
            title: NSLocalizedString("places.empty.title", comment: ""),
            message: presenter.searchText.isEmpty
                ? NSLocalizedString("places.empty.message", comment: "")
                : NSLocalizedString("places.empty.search_message", comment: ""),
            systemImage: "mappin.slash"
        )
    }

    @ViewBuilder
    private func locationsList() -> some View {
        LocationListView(
            locations: presenter.filteredLocations,
            onSelect: { location in
                if let url = presenter.deepLink(for: location) {
                    openURL(url)
                }
            }
        )
    }

    @ToolbarContentBuilder
    private func searchToolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showingCustomLocation = true
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .accessibilityIdentifier("open-custom-location")
            .accessibilityLabel(NSLocalizedString("places.search.accessibility_label", comment: ""))
            .accessibilityHint(NSLocalizedString("places.search.accessibility_hint", comment: ""))
        }
    }
}
