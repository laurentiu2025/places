//
//  CoordinateSearchTabView.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import SwiftUI

struct CoordinateSearchTabView: View {
    @ObservedObject var presenter: CustomLocationPresenter
    let onDismiss: () -> Void
    @Environment(\.openURL) private var openURL

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
            coordinateField(
                title: NSLocalizedString("custom_location.coordinates.latitude", comment: ""),
                value: Binding(get: { presenter.state.latitude }, set: { presenter.latitudeDidChange(sanitizedCoordinate($0)) }),
                placeholder: "52.3676",
                identifier: "latitude-field",
                hint: NSLocalizedString("custom_location.coordinates.latitude_hint", comment: "")
            )
            coordinateField(
                title: NSLocalizedString("custom_location.coordinates.longitude", comment: ""),
                value: Binding(get: { presenter.state.longitude }, set: { presenter.longitudeDidChange(sanitizedCoordinate($0)) }),
                placeholder: "4.9041",
                identifier: "longitude-field",
                hint: NSLocalizedString("custom_location.coordinates.longitude_hint", comment: "")
            )
            if let error = presenter.state.coordinateError {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .accessibilityLabel(error)
                    .accessibilityIdentifier("coordinate-validation-error")
            }
            Button {
                if let url = presenter.submitCoordinates() {
                    openURL(url)
                    onDismiss()
                }
            } label: {
                Label(NSLocalizedString("custom_location.coordinates.open_map", comment: ""), systemImage: "map")
                    .frame(maxWidth: .infinity)
            }
            .accessibilityIdentifier("submit-coordinates")
            .accessibilityLabel(NSLocalizedString("custom_location.coordinates.open_map", comment: ""))
            .accessibilityHint(NSLocalizedString("custom_location.coordinates.open_map_hint", comment: ""))
            .buttonStyle(.borderedProminent)
            .frame(minHeight: 44)
            .disabled(presenter.state.latitude.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                      presenter.state.longitude.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .scrollIndicators(.visible)
    }

    private func sanitizedCoordinate(_ value: String) -> String {
        let filtered = value.filter { $0 >= "0" && $0 <= "9" || $0 == "." || $0 == "-" }
        let isNegative = filtered.first == "-"
        let withoutSigns = filtered.replacingOccurrences(of: "-", with: "")
        let decimalParts = withoutSigns.split(separator: ".", omittingEmptySubsequences: false)
        let normalized = decimalParts.count > 1
            ? String(decimalParts[0]) + "." + decimalParts.dropFirst().joined()
            : withoutSigns
        return (isNegative ? "-" : "") + normalized
    }

    @ViewBuilder
    private func coordinateField(title: String, value: Binding<String>, placeholder: String, identifier: String, hint: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .fixedSize(horizontal: false, vertical: true)
            TextField(placeholder, text: value)
                .keyboardType(.numbersAndPunctuation)
                .textInputAutocapitalization(.never)
                .accessibilityLabel(title)
                .accessibilityHint(hint)
                .accessibilityIdentifier(identifier)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .frame(minHeight: 44)
                .accessibilityElement(children: .contain)
        }
    }
}
