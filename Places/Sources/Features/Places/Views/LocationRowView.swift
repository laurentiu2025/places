//
//  LocationRowView.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import SwiftUI

struct LocationRowView: View {
    let place: PlaceDisplayModel

    var body: some View {
        rowContent()
    }

    @ViewBuilder
    private func rowContent() -> some View {
        HStack(alignment: .center, spacing: 12) {
            locationIcon()
            VStack(alignment: .leading, spacing: 4) {
                locationTitle()
                locationCoordinates()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            disclosureIcon()
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(place.name), \(place.coordinates)")
    }

    @ViewBuilder
    private func locationIcon() -> some View {
        Image(systemName: "mappin.and.ellipse")
            .font(.title3)
            .foregroundStyle(.tint)
            .frame(minWidth: 44, minHeight: 44)
            .background(.tint.opacity(0.10), in: RoundedRectangle(cornerRadius: 10))
    }

    @ViewBuilder
    private func locationTitle() -> some View {
        Text(place.name)
            .font(.body)
            .foregroundStyle(place.isUnnamed ? Color.secondary : Color.primary)
            .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder
    private func locationCoordinates() -> some View {
        Text(place.coordinates)
            .font(.caption.monospacedDigit())
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder
    private func disclosureIcon() -> some View {
        Image(systemName: "chevron.right")
            .font(.caption.weight(.semibold))
            .foregroundStyle(.tertiary)
    }
}
