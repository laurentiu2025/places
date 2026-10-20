//
//  EmptyStateView.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    let systemImage: String

    var body: some View {
        emptyStateContent()
    }

    @ViewBuilder
    private func emptyStateContent() -> some View {
        VStack(spacing: 12) {
            stateIcon()
            stateTitle()
            stateMessage()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("empty-state")
    }

    @ViewBuilder
    private func stateIcon() -> some View {
        Image(systemName: systemImage)
            .font(.largeTitle)
            .foregroundStyle(.secondary)
            .accessibilityHidden(true)
    }

    @ViewBuilder
    private func stateTitle() -> some View {
        Text(title)
            .font(.headline)
            .multilineTextAlignment(.center)
            .accessibilityAddTraits(.isHeader)
    }

    @ViewBuilder
    private func stateMessage() -> some View {
        Text(message)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
    }
}
