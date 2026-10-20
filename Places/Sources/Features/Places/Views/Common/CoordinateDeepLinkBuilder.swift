//
//  CoordinateDeepLinkBuilder.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation

enum CoordinateDeepLinkBuilder {
    static func makeURL(latitude: Double, longitude: Double) -> URL? {
        var components = URLComponents()
        components.scheme = "wikipedia-clone"
        components.host = "places"
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude))
        ]
        return components.url
    }
}
