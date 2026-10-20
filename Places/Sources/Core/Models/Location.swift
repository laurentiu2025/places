//
//  Location.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation

struct Location: Identifiable, Decodable, Hashable, Sendable {
    let name: String?
    let lat: Double
    let long: Double

    var id: String {
        "\(lat),\(long)"
    }

    init(name: String) {
        self.name = name
        lat = 0
        long = 0
    }

    init(name: String, lat: Double, long: Double) {
        self.name = name
        self.lat = lat
        self.long = long
    }
}
