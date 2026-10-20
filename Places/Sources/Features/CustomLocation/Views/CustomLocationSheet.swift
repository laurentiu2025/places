//
//  CustomLocationSheet.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import SwiftUI

struct CustomLocationSheet: View {
    @StateObject private var presenter: CustomLocationPresenter
    @Environment(\.dismiss) private var dismiss
    @State private var entryMode = 0

    init(presenter: CustomLocationPresenter? = nil) {
        _presenter = StateObject(wrappedValue: presenter ?? CustomLocationAssembly.makePresenter())
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                entryModePicker()
                Group {
                    if entryMode == 0 {
                        PlaceNameSearchTabView(presenter: presenter, onDismiss: { dismiss() })
                    } else if entryMode == 1 {
                        CoordinateSearchTabView(presenter: presenter, onDismiss: { dismiss() })
                    } else {
                        MapSelectionTabView(presenter: presenter, onDismiss: { dismiss() })
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle(NSLocalizedString("custom_location.title", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("common.cancel", comment: "")) {
                        dismiss()
                    }
                    .frame(minWidth: 44, minHeight: 44)
                    .accessibilityIdentifier("cancel-custom-location")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground).ignoresSafeArea())
    }

    @ViewBuilder
    private func entryModePicker() -> some View {
        Picker(NSLocalizedString("custom_location.mode.label", comment: ""), selection: $entryMode) {
            Text(NSLocalizedString("custom_location.mode.place", comment: "")).tag(0)
            Text(NSLocalizedString("custom_location.mode.coordinates", comment: "")).tag(1)
            Text(NSLocalizedString("custom_location.mode.map", comment: "")).tag(2)
        }
        .pickerStyle(.segmented)
        .fixedSize(horizontal: false, vertical: true)
        .padding(4)
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 13, style: .continuous))
        .accessibilityLabel(NSLocalizedString("custom_location.mode.label", comment: ""))
        .accessibilityIdentifier("custom-location-mode-picker")
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 12)
    }
}
