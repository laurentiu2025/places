//
//  LoadingStateView.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import SwiftUI

struct LoadingStateView: View {
    var title = NSLocalizedString("places.loading", comment: "")

    var body: some View {
        loadingContent()
    }

    @ViewBuilder
    private func loadingContent() -> some View {
        VStack(spacing: 12) {
            ProgressView()
            loadingTitle()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityIdentifier("loading-state")
    }

    @ViewBuilder
    private func loadingTitle() -> some View {
        Text(title)
            .foregroundStyle(.secondary)
    }
}
