//
//  ErrorStateView.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        errorContent()
    }

    @ViewBuilder
    private func errorContent() -> some View {
        VStack(spacing: 12) {
            errorIcon()
            errorTitle()
            errorMessage()
            retryButton()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private func errorIcon() -> some View {
        Image(systemName: "wifi.exclamationmark")
            .font(.largeTitle)
            .foregroundStyle(.secondary)
            .accessibilityHidden(true)
    }

    @ViewBuilder
    private func errorTitle() -> some View {
        Text(NSLocalizedString("common.error.title", comment: ""))
            .font(.headline)
            .multilineTextAlignment(.center)
            .accessibilityAddTraits(.isHeader)
    }

    @ViewBuilder
    private func errorMessage() -> some View {
        Text(message)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .accessibilityIdentifier("error-message")
    }

    @ViewBuilder
    private func retryButton() -> some View {
        Button(actionTitle, action: action)
            .buttonStyle(.borderedProminent)
            .frame(minHeight: 44)
            .accessibilityIdentifier("retry-loading")
            .padding(.top, 4)
    }
}
