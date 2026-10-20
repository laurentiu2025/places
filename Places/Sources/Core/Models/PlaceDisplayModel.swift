//
//  PlaceDisplayModel.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation

struct PlaceDisplayModel: Identifiable, Hashable {
    let location: Location
    let name: String
    let coordinates: String
    let isUnnamed: Bool

    var id: String { location.id }

    init(location: Location, unnamedPlaceholder: String = NSLocalizedString("places.location.unnamed", comment: "")) {
        self.location = location
        isUnnamed = location.name?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        name = isUnnamed ? unnamedPlaceholder : location.name!
        coordinates = String(format: "%.4f, %.4f", location.lat, location.long)
    }
}
