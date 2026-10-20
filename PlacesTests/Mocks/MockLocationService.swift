//
//  MockLocationService.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation
@testable import Places

struct MockLocationService: LocationFetching {
    let result: Result<[Location], Error>
    func fetchLocations() async throws -> [Location] { try result.get() }
}
