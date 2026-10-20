# Places: iOS Application

## Overview

Places is an iOS application built with Swift and SwiftUI. It displays a list of locations and provides a custom location search experience with three input modes.

1. **Place name:** Search for a place and resolve it to geographic coordinates.
2. **Coordinates:** Enter latitude and longitude manually.
3. **Map:** Select a location using an interactive map.

The selected location is passed to the companion Wikipedia Clone application through a custom URL scheme containing its geographic coordinates.

## Requirements

1. macOS compatible with Xcode 27.0
2. Xcode 27.0
3. An iOS Simulator or compatible iOS device

Places has no external dependencies to install.

## Getting Started

1. Clone or download this repository.
2. Open `Places.xcodeproj` in Xcode 27.0.
3. Select the `Places` scheme.
4. Choose an iOS Simulator or connected device.
5. Build and run the application using **Product → Run** (`⌘R`).

No additional dependency installation is required for Places.

## Companion Application: Wikipedia Clone

The complete location selection flow depends on the companion [Wikipedia iOS Clone](https://github.com/laurentiu2025/wikipedia-ios-clone) application, which receives the selected coordinates through a deep link.

Wikipedia Clone has its own dependencies, which must be resolved according to that repository's setup instructions.

Before testing the complete cross app flow:

1. Clone the [Wikipedia iOS Clone repository](https://github.com/laurentiu2025/wikipedia-ios-clone).
2. Open its Xcode project and resolve its dependencies.
3. Select an iOS Simulator and run Wikipedia Clone from Xcode.
4. Keep the debugger attached while the app runs in the Simulator.
5. Open and run `Places.xcodeproj` in the same Simulator.

When a location is selected in Places, the app attempts to open a URL using the `wikipedia-clone://places` scheme and passes the selected coordinates.

**Important:** Wikipedia Clone must be running from Xcode in the Simulator with the debugger attached before testing the complete cross app flow.

## Architecture

The application follows the **VIPER architecture**, separating responsibilities into five components: View, Interactor, Presenter, Entity, and Router.

### VIPER Components

**View:** Displays the interface using SwiftUI and forwards user interactions to the presenter.

**Interactor:** Handles business logic and data operations, including retrieving locations, searching suggestions, and resolving place names.

**Presenter:** Coordinates presentation logic, manages view state, processes user actions, and prepares information for display.

**Entity:** Represents domain data, such as locations and geographic coordinates.

**Router:** Handles navigation and constructs deep links to the Wikipedia Clone application.

### Why VIPER?

VIPER was chosen to keep the application modular and responsibilities clearly separated.

Its main benefits include:

1. **Separation of concerns:** UI rendering, business logic, data operations, and navigation are handled independently.
2. **Testability:** Presenters, interactors, and routing logic can be tested in isolation using protocols and mock dependencies.
3. **Maintainability:** Changes to one component can often be made without affecting the entire feature.
4. **Scalability:** New functionality can be added through dedicated modules with well defined responsibilities.
5. **Dependency injection:** Dependencies can be replaced with mocks or alternative implementations for testing.

The application uses SwiftUI for its declarative interface while retaining VIPER's separation of responsibilities.

## Testing

The project includes unit tests and UI tests.

### Unit Tests

Unit tests use Apple's Swift Testing framework, including `import Testing`, `@Test`, and `#expect`, to verify application logic and state transitions.

### UI Tests

UI automation uses XCTest and XCUIAutomation to exercise application screens and interactions.

The UI tests use the following launch argument:

`-ui-testing-mock-places`

This argument enables deterministic mock data for UI testing.

To run the tests, select the appropriate test scheme or test target in Xcode and choose **Product → Test** (`⌘U`).

## Technologies

1. Swift
2. SwiftUI
3. Combine
4. MapKit
5. Core Location
6. URL schemes and deep linking
7. VIPER architecture
8. Swift Testing
9. XCTest and XCUIAutomation

## Project Structure

The source code is organized by feature under `Sources/Features`. The Places and CustomLocation features are maintained separately, with their respective VIPER components grouped by responsibility.

Shared view utilities are located in a common folder, keeping reusable functionality separate from feature specific implementations.

This organization helps developers navigate the codebase and maintain clear boundaries between features.

## Potential Improvements

1. **Logging and analytics:** Introduce structured error logging and privacy conscious analytics.
2. **Networking:** Mock HTTP requests using `URLProtocol` and introduce a lightweight networking abstraction around `URLSession` for easier testing and flexibility.
3. **Design system and accessibility:** Standardize fonts and spacing, and improve layouts for larger preferred text sizes.
4. **Code organization:** Keep each class and enum in its own file where appropriate, and use typed errors with `throws`.
5. **Test coverage:** Expand unit and UI tests to cover more success, failure, and edge cases.
6. **Deep link handling:** Show an error if Wikipedia Clone cannot be opened, and mock deep link opening during UI tests.
7. **Test configuration:** Enable mock services through a dedicated UI testing build configuration or compiler flag, keeping production behavior unchanged.
