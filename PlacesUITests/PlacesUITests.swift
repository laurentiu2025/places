//
//  PlacesUITests.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import XCTest

final class PlacesUITests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-ui-testing-mock-places")
        app.launchArguments.append("-ui-testing-disable-animations")
    }
    
    func testCoordinateSubmitStartsDisabledUntilBothFieldsAreFilled() {
        // Given the custom-location screen is open in Coordinates mode
        app.launch()
        let openButton = app.buttons["open-custom-location"]
        XCTAssertTrue(openButton.waitForExistence(timeout: 5))
        openButton.tap()
        
        let coordinatesTab = app.buttons["Coordinates"]
        XCTAssertTrue(coordinatesTab.waitForExistence(timeout: 3))
        coordinatesTab.tap()
        
        // When the coordinate fields are filled one at a time
        let submitButton = app.buttons["submit-coordinates"]
        XCTAssertTrue(submitButton.waitForExistence(timeout: 3))
        XCTAssertFalse(submitButton.isEnabled)
        
        let latitudeField = app.textFields["latitude-field"]
        let longitudeField = app.textFields["longitude-field"]
        latitudeField.tap()
        latitudeField.typeText("52.3")
        
        // Then submission remains disabled until both fields are filled
        XCTAssertFalse(submitButton.isEnabled)
        
        // When the longitude is entered
        longitudeField.tap()
        longitudeField.typeText("4.9")
        
        // Then submission becomes enabled
        XCTAssertTrue(submitButton.isEnabled)
    }
    
    func testPlaceSearchDisplaysMockSuggestion() {
        // Given the custom-location screen is open in Place name mode
        app.launch()
        let openButton = app.buttons["open-custom-location"]
        XCTAssertTrue(openButton.waitForExistence(timeout: 5))
        openButton.tap()
        
        // When the user searches for Amsterdam
        let searchField = app.textFields["location-name-search-field"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
        searchField.tap()
        searchField.typeText("Amsterdam")
        
        // Then the mock Amsterdam suggestion is displayed
        XCTAssertTrue(
            app.buttons["location-suggestion-Amsterdam"]
                .waitForExistence(timeout: 5)
        )
    }
}
