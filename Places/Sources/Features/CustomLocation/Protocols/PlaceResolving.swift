//
//  PlaceResolving.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation

protocol PlaceResolving {
    func resolvePlace(named name: String) async throws -> Location
}
