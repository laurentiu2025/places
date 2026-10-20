//
//  LocationListView.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import SwiftUI

struct LocationListView: View {
    let locations: [PlaceDisplayModel]
    let onSelect: (Location) -> Void

    var body: some View {
        locationsList()
    }

    @ViewBuilder
    private func locationsList() -> some View {
        List(locations) { location in
            locationButton(for: location)
        }
        .listStyle(.plain) 
    }

    @ViewBuilder
    private func locationButton(for location: PlaceDisplayModel) -> some View {
        Button {
            onSelect(location.location)
        } label: {
            LocationRowView(place: location)
        }
        .buttonStyle(.plain)
        .frame(minHeight: 44)
        .accessibilityLabel("\(location.name), \(location.coordinates)")
        .accessibilityHint(NSLocalizedString("places.location.accessibility_hint", comment: ""))
        .accessibilityIdentifier("place-row-\(location.id)")
    }
}
