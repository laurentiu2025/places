//
//  MapSelectionTabView.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import SwiftUI
import MapKit

struct MapSelectionTabView: View {
    @ObservedObject var presenter: CustomLocationPresenter
    let onDismiss: () -> Void

    @Environment(\.openURL) private var openURL

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 37.7748,
                longitude: -122.4194
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.08,
                longitudeDelta: 0.08
            )
        )
    )

    @State private var mapCenter = CLLocationCoordinate2D(
        latitude: 37.7748,
        longitude: -122.4194
    )

    var body: some View {
        VStack(spacing: 0) {
            mapView()
                .padding(.horizontal, 16)
                .padding(.top, 8)
            selectedCoordinatesView()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            openWikipediaCloneButton()
        }
    }

    @ViewBuilder
    private func mapView() -> some View {
        Map(
            position: $cameraPosition,
            interactionModes: [.pan, .zoom]
        )
        .overlay {
            Image(systemName: "mappin")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.red)
                .offset(y: -17)
                .allowsHitTesting(false)
        }
        .onMapCameraChange(frequency: .continuous) { context in
            mapCenter = context.region.center
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityIdentifier("custom-location-map")
        .accessibilityLabel(
            NSLocalizedString(
                "custom_location.map.accessibility_label",
                comment: ""
            )
        )
        .accessibilityHint(
            NSLocalizedString(
                "custom_location.map.accessibility_hint",
                comment: ""
            )
        )
    }

    @ViewBuilder
    private func selectedCoordinatesView() -> some View {
        Text(
            String(
                format: "%.4f, %.4f",
                mapCenter.latitude,
                mapCenter.longitude
            )
        )
        .font(.footnote.monospacedDigit())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            NSLocalizedString(
                "custom_location.map.selected_coordinates",
                comment: ""
            )
        )
        .accessibilityValue(
            String(
                format: "%.4f, %.4f",
                mapCenter.latitude,
                mapCenter.longitude
            )
        )
        .accessibilityIdentifier("map-selected-coordinates")
        .padding(.vertical, 10)
    }

    @ViewBuilder
    private func openWikipediaCloneButton() -> some View {
        Button {
            if let url = presenter.openMapCoordinates(
                latitude: mapCenter.latitude,
                longitude: mapCenter.longitude
            ) {
                openURL(url)
                onDismiss()
            }
        } label: {
            Label(
                NSLocalizedString(
                    "custom_location.map.open_wikipedia_clone",
                    comment: ""
                ),
                systemImage: "map"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .frame(minHeight: 44)
        .accessibilityLabel(
            NSLocalizedString(
                "custom_location.map.open_wikipedia_clone",
                comment: ""
            )
        )
        .accessibilityHint(
            NSLocalizedString(
                "custom_location.map.open_wikipedia_clone_hint",
                comment: ""
            )
        )
        .accessibilityIdentifier("open-map-coordinates")
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
}
