//
//  PlacesLaunchArgumentUITests.swift
//  ABN AMRO
//
//  Created by Laurentiu Cociu on 10/20/26.
//

import XCTest

final class PlacesLaunchArgumentUITests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-ui-testing-mock-places")
        app.launchArguments.append("-ui-testing-disable-animations")
    }
    
    override func tearDownWithError() throws {
        if app.state != .notRunning {
            app.terminate()
        }
    }
    
    func testCustomLocationOpensAndShowsThreeModes() {
        // Given the app is running with mock data
        app.launch()
        XCTAssertTrue(app.buttons["open-custom-location"].waitForExistence(timeout: 5))
        
        // When the custom-location screen is opened
        app.buttons["open-custom-location"].tap()
        
        // Then all three location modes are available
        XCTAssertTrue(app.buttons["Place name"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Coordinates"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Map"].waitForExistence(timeout: 3))
    }
    
    func testSwitchingToCoordinateModeShowsLatitudeAndLongitudeFields() {
        // Given the custom-location screen is open
        app.launch()
        XCTAssertTrue(app.buttons["open-custom-location"].waitForExistence(timeout: 5))
        app.buttons["open-custom-location"].tap()
        
        // When the Coordinates tab is selected
        let coordinatesButton = app.buttons["Coordinates"]
        XCTAssertTrue(coordinatesButton.waitForExistence(timeout: 3))
        coordinatesButton.tap()
        
        // Then latitude and longitude inputs are shown
        XCTAssertTrue(app.textFields["latitude-field"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.textFields["longitude-field"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["submit-coordinates"].waitForExistence(timeout: 3))
    }
    
    func testSwitchingToMapModeShowsMapAndCoordinateAction() {
        // Given the custom-location screen is open
        app.launch()
        XCTAssertTrue(app.buttons["open-custom-location"].waitForExistence(timeout: 5))
        app.buttons["open-custom-location"].tap()
        
        // When the Map tab is selected
        let mapButton = app.buttons["Map"]
        XCTAssertTrue(mapButton.waitForExistence(timeout: 3))
        mapButton.tap()
        
        // Then the map and coordinate action are visible
        let mapElement = app.otherElements["custom-location-map"]
        let mapView = app.maps["custom-location-map"]
        XCTAssertTrue(mapElement.waitForExistence(timeout: 5) || mapView.exists)
        XCTAssertTrue(app.buttons["open-map-coordinates"].exists)
    }
    
    func testCoordinateModeCanSwitchBackToPlaceSearch() {
        // Given the Coordinates tab is selected
        app.launch()
        XCTAssertTrue(app.buttons["open-custom-location"].waitForExistence(timeout: 5))
        app.buttons["open-custom-location"].tap()
        let coordinatesButton = app.buttons["Coordinates"]
        XCTAssertTrue(coordinatesButton.waitForExistence(timeout: 3))
        coordinatesButton.tap()
        
        // When the Place name tab is selected
        let placeNameButton = app.buttons["Place name"]
        XCTAssertTrue(placeNameButton.waitForExistence(timeout: 3))
        placeNameButton.tap()
        
        // Then the location search field is visible again
        XCTAssertTrue(app.textFields["Location name"].waitForExistence(timeout: 3))
    }
    func testCoordinateFieldsHaveAccessibleLabels() {
        // Given the custom-location screen is open in Coordinates mode
        app.launch()
        XCTAssertTrue(app.buttons["open-custom-location"].waitForExistence(timeout: 5))
        app.buttons["open-custom-location"].tap()
        let coordinatesButton = app.buttons["Coordinates"]
        XCTAssertTrue(coordinatesButton.waitForExistence(timeout: 3))
        coordinatesButton.tap()
        
        // When VoiceOver-facing field metadata is queried through UI automation
        let latitudeField = app.textFields["latitude-field"]
        let longitudeField = app.textFields["longitude-field"]
        
        // Then both fields expose meaningful accessible labels
        XCTAssertTrue(latitudeField.waitForExistence(timeout: 3))
        XCTAssertEqual(latitudeField.label, "Latitude")
        XCTAssertTrue(longitudeField.exists)
        XCTAssertEqual(longitudeField.label, "Longitude")
    }
    
    func testPlaceSearchFieldHasAccessibleLabel() {
        // Given the custom-location screen is open in Place name mode
        app.launch()
        XCTAssertTrue(app.buttons["open-custom-location"].waitForExistence(timeout: 5))
        app.buttons["open-custom-location"].tap()
        
        // When the location search field is queried
        let searchField = app.textFields["location-name-search-field"]
        
        // Then the field exposes its accessible name
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
        XCTAssertEqual(searchField.label, "Location name")
    }
    
    func testCoordinateValidationShowsErrorForOutOfRangeValues() {
        // Given the custom-location screen is open in Coordinates mode
        app.launch()
        XCTAssertTrue(app.buttons["open-custom-location"].waitForExistence(timeout: 5))
        app.buttons["open-custom-location"].tap()
        let coordinatesButton = app.buttons["Coordinates"]
        XCTAssertTrue(coordinatesButton.waitForExistence(timeout: 3))
        coordinatesButton.tap()
        
        // When out-of-range coordinates are submitted
        let latitudeField = app.textFields["latitude-field"]
        let longitudeField = app.textFields["longitude-field"]
        XCTAssertTrue(latitudeField.waitForExistence(timeout: 3))
        latitudeField.tap()
        latitudeField.typeText("91")
        longitudeField.tap()
        longitudeField.typeText("181")
        app.buttons["submit-coordinates"].tap()
        
        // Then a coordinate validation error is displayed
        XCTAssertTrue(app.staticTexts["coordinate-validation-error"].waitForExistence(timeout: 3))
    }
    
    func testSwitchingBetweenAllTabsKeepsCustomLocationSheetOpen() {
        // Given the custom-location screen is open
        app.launch()
        XCTAssertTrue(app.buttons["open-custom-location"].waitForExistence(timeout: 5))
        app.buttons["open-custom-location"].tap()
        
        // When the user switches through Coordinates, Map, and Place name
        let coordinatesButton = app.buttons["Coordinates"]
        let mapButton = app.buttons["Map"]
        let placeNameButton = app.buttons["Place name"]
        XCTAssertTrue(coordinatesButton.waitForExistence(timeout: 3))
        coordinatesButton.tap()
        XCTAssertTrue(app.textFields["latitude-field"].waitForExistence(timeout: 3))
        mapButton.tap()
        XCTAssertTrue(app.buttons["open-map-coordinates"].waitForExistence(timeout: 3))
        placeNameButton.tap()
        
        // Then the Place name search field is visible and the sheet remains open
        XCTAssertTrue(app.textFields["location-name-search-field"].waitForExistence(timeout: 3))
    }
}
