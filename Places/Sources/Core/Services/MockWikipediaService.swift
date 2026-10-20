//
//  MockWikipediaService.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation

struct MockWikipediaService: WikipediaServicing {
    private let suggestions = [
        "UI Test Amsterdam",
        "UI Test Copenhagen",
        "UI Test Mumbai",
        "Amsterdam",
        "San Francisco"
    ]

    func articleURL(for location: String) -> URL? {
        WikipediaService().articleURL(for: location)
    }

    func searchSuggestions(for query: String) async throws -> [String] {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard normalizedQuery.count >= 2 else { return [] }
        return suggestions.filter { $0.localizedCaseInsensitiveContains(normalizedQuery) }
    }
}
