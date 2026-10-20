//
//  CustomLocationAssembly.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import Foundation

@MainActor
enum CustomLocationAssembly {
    static func makePresenter() -> CustomLocationPresenter {
        let isUITesting = ProcessInfo.processInfo.arguments.contains(AppLaunchArguments.useMockPlaces)
        let wikipediaService: any WikipediaServicing = isUITesting ? MockWikipediaService() : WikipediaService()
        let placeResolver: any PlaceResolving = isUITesting ? MockPlaceResolver() : MapKitPlaceResolver()

        return CustomLocationPresenter(
            interactor: CustomLocationInteractor(
                wikipediaService: wikipediaService,
                placeResolver: placeResolver
            ),
            router: CustomLocationRouter()
        )
    }
}
