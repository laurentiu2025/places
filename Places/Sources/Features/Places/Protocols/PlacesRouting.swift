//
//  PlacesRouting.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation

protocol PlacesRouting {
    func coordinateDeepLink(latitude: Double, longitude: Double) -> URL?
}
