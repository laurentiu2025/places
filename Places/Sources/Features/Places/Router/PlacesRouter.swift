//
//  PlacesRouter.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation

struct PlacesRouter: PlacesRouting {
    func coordinateDeepLink(latitude: Double, longitude: Double) -> URL? {
        CoordinateDeepLinkBuilder.makeURL(latitude: latitude, longitude: longitude)
    }
}
