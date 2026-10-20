//
//  CustomLocationInteracting.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation

protocol CustomLocationInteracting {
    func searchSuggestions(for query: String) async throws -> [String]
    func resolvePlace(named name: String) async throws -> Location
}
