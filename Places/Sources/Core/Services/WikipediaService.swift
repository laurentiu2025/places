//
//  WikipediaService.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation

protocol WikipediaServicing {
    func articleURL(for location: String) -> URL?
    func searchSuggestions(for query: String) async throws -> [String]
}

struct WikipediaService: WikipediaServicing {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func articleURL(for location: String) -> URL? {
        let trimmed = location.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        var components = URLComponents()
        components.scheme = "https"
        components.host = "en.wikipedia.org"
        components.path = "/wiki/" + trimmed.replacingOccurrences(of: " ", with: "_")
        return components.url
    }

    func searchSuggestions(for query: String) async throws -> [String] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else { return [] }

        var components = URLComponents(string: "https://en.wikipedia.org/w/api.php")
        components?.queryItems = [
            URLQueryItem(name: "action", value: "opensearch"),
            URLQueryItem(name: "search", value: trimmed),
            URLQueryItem(name: "limit", value: "8"),
            URLQueryItem(name: "namespace", value: "0"),
            URLQueryItem(name: "format", value: "json")
        ]

        guard let url = components?.url else { return [] }
        var request = URLRequest(url: url)
        request.setValue("PlacesVIPER/1.0 (location search)", forHTTPHeaderField: "User-Agent")

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        guard let payload = try JSONSerialization.jsonObject(with: data) as? [Any],
              payload.count > 1,
              let titles = payload[1] as? [String] else {
            return []
        }

        return Array(titles.prefix(8))
    }
}
