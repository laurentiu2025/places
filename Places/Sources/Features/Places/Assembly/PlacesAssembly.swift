//
//  PlacesAssembly.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation

@MainActor
enum PlacesAssembly {
    static func makePresenter() -> PlacesPresenter {
        let service: any LocationFetching = ProcessInfo.processInfo.arguments.contains(AppLaunchArguments.useMockPlaces)
            ? MockPlacesService()
            : LocationService()
        return PlacesPresenter(interactor: PlacesInteractor(service: service), router: PlacesRouter())
    }
}
