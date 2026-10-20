//
//  PlaceNameSearchTabView.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import SwiftUI

struct PlaceNameSearchTabView: View {
    @ObservedObject var presenter: CustomLocationPresenter
    let onDismiss: () -> Void
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(spacing: 0) {
            searchField()
            resultsSection()
            bottomAction()
        }
    }

    @ViewBuilder
    private func searchField() -> some View {
        TextField(NSLocalizedString("custom_location.search.placeholder", comment: ""), text: Binding(
            get: { presenter.state.query },
            set: { presenter.queryDidChange($0) }
        ))
        .textInputAutocapitalization(.words)
        .autocorrectionDisabled()
        .submitLabel(.go)
        .onSubmit { submitQuery() }
        .accessibilityLabel(NSLocalizedString("custom_location.search.accessibility_label", comment: ""))
        .accessibilityHint(NSLocalizedString("custom_location.search.accessibility_hint", comment: ""))
        .accessibilityIdentifier("location-name-search-field")
        .frame(minHeight: 44)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private func resultsSection() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                switch presenter.state.resolutionState {
                case .resolving:
                    resolvingPlaceView()
                case .failed(let message):
                    placeSearchErrorView(message)
                case .idle:
                    switch presenter.state.searchState {
                    case .searching:
                        searchingView()
                    case .results:
                        suggestionsView()
                    case .noResults, .failed:
                        emptyResultsView()
                    case .idle:
                        searchHintView()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
        .scrollIndicators(.visible)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func searchingView() -> some View {
        HStack(spacing: 10) {
            ProgressView()
            Text(NSLocalizedString("custom_location.searching", comment: ""))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
    }

    @ViewBuilder
    private func suggestionsView() -> some View {
        Text(NSLocalizedString("custom_location.suggestions.title", comment: ""))
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 12)
            .padding(.top, 10)
            .padding(.bottom, 8)
        LazyVStack(spacing: 0) {
            ForEach(presenter.state.suggestions, id: \.self) { suggestion in
                Button {
                    Task {
                        if let url = await presenter.selectSuggestion(suggestion) {
                            openURL(url)
                            onDismiss()
                        }
                    }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "mappin.and.ellipse").foregroundStyle(.secondary)
                        Text(suggestion).foregroundStyle(.primary).multilineTextAlignment(.leading)
                        Spacer(minLength: 0)
                        Image(systemName: "arrow.up.right").font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 13)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .frame(minHeight: 44)
                .accessibilityLabel(suggestion)
                .accessibilityHint(NSLocalizedString("custom_location.suggestion.accessibility_hint", comment: ""))
                .accessibilityIdentifier("location-suggestion-\(suggestion)")
                if suggestion != presenter.state.suggestions.last {
                    Divider().padding(.leading, 40)
                }
            }
        }
    }

    @ViewBuilder
    private func resolvingPlaceView() -> some View {
        HStack(spacing: 10) {
            ProgressView()
            Text(NSLocalizedString("custom_location.search.resolving_place", comment: ""))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(NSLocalizedString("custom_location.search.resolving_place", comment: ""))
        .accessibilityIdentifier("custom-location-resolving-place")
    }

    @ViewBuilder
    private func placeSearchErrorView(_ message: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(message).font(.subheadline).foregroundStyle(.secondary).accessibilityAddTraits(.isStaticText)
            Button(NSLocalizedString("custom_location.search.retry", comment: "")) { submitQuery() }
                .accessibilityIdentifier("retry-place-search")
                .frame(minHeight: 44)
        }
        .padding(12)
        .accessibilityIdentifier("custom-location-place-search-error")
    }

    @ViewBuilder
    private func emptyResultsView() -> some View {
        Text(presenter.state.searchState == .failed
             ? NSLocalizedString("custom_location.search.error", comment: "")
             : NSLocalizedString("custom_location.search.empty", comment: ""))
            .font(.subheadline).foregroundStyle(.secondary).padding(12)
    }

    @ViewBuilder
    private func searchHintView() -> some View {
        Text(NSLocalizedString("custom_location.search.hint", comment: ""))
            .font(.subheadline).foregroundStyle(.secondary).padding(12)
    }

    @ViewBuilder
    private func bottomAction() -> some View {
        Divider()
        PrimaryButton(
            title: NSLocalizedString("custom_location.open_typed_location", comment: ""),
            systemImage: "arrow.up.right.square",
            isDisabled: presenter.trimmedQuery.isEmpty || presenter.state.resolutionState == .resolving,
            action: submitQuery
        )
        .padding()
    }

    private func submitQuery() {
        Task {
            if let url = await presenter.submitQuery() {
                openURL(url)
                onDismiss()
            }
        }
    }
}
