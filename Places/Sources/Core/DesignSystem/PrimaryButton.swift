//
//  PrimaryButton.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var systemImage: String? = nil
    var isDisabled = false
    let action: () -> Void

    var body: some View {
        buttonContent()
    }

    @ViewBuilder
    private func buttonContent() -> some View {
        Button(action: action) {
            buttonLabel()
        }
        .buttonStyle(.borderedProminent)
        .frame(minHeight: 44)
        .disabled(isDisabled)
        .accessibilityLabel(title)
    }

    @ViewBuilder
    private func buttonLabel() -> some View {
        Label(title, systemImage: systemImage ?? "arrow.right")
            .frame(maxWidth: .infinity)
    }
}
