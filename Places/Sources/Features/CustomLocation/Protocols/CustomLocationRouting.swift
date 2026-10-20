//
//  CustomLocationRouting.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation

protocol CustomLocationRouting {
    func coordinateDeepLink(latitude: Double, longitude: Double) -> URL?
}
