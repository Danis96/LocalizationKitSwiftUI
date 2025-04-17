# LocalizationKitSwiftUI

A Swift package providing robust localization support for SwiftUI applications. This package simplifies the implementation of multiple language support in your iOS and macOS applications.

## Features

- Simple configuration of supported languages
- Dynamic language switching at runtime
- Observer pattern for UI updates on language changes
- Fallback mechanism to handle missing translations
- SwiftUI view modifiers for reactive localization
- Thread-safe implementation with Sendable conformance

## Requirements

- iOS 17.0+ / macOS 14.0+
- Swift 6.1+
- Xcode 15.0+

## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/LocalizationKitSwiftUI.git", from: "1.0.0")
]
```

Or add it directly in Xcode using File > Add Package Dependencies...

## Usage

### Configuration

```swift
import LocalizationKitSwiftUI

// Configure localization
let config = DefaultLocalizationConfiguration(
    defaultLocale: "en",
    supportedLocales: ["en", "es", "fr", "de"],
    fallbackLocale: "en",
    bundleIdentifier: Bundle.main.bundleIdentifier ?? ""
)

// Initialize the localization manager
let manager = LocalizationManagerImplementation(configuration: config)

// Register the manager with Factory container
Container.shared.register(
    type: LocalizationManagerProtocol.self, 
    instance: manager
)
```

### Changing Language

```swift
// Get the localization manager
@Injected(\.localizationManager) private var localizationManager: LocalizationManagerProtocol

// Set the current locale
do {
    try localizationManager.setLocale("fr")
} catch {
    print("Failed to set locale: \(error.localizedDescription)")
}
```

### Accessing Localized Strings

```swift
// Get localized string from a specific module
let localizedText = localizationManager.localizedString("welcome_message", from: "Common")
```

### Observer Pattern

The package includes an observer pattern to update your UI when the locale changes:

```swift
// Create a view that responds to locale changes
struct LocalizedView: View, LocalizationObservingProtocol {
    @State private var needsUpdate = false
    
    var body: some View {
        Text("Hello World")
            .onAppear {
                // Register as an observer
                localizationManager.addObserver(self)
            }
            .onDisappear {
                // Unregister as an observer
                localizationManager.removeObserver(self)
            }
            .id(needsUpdate) // Force view update
    }
    
    func localeDidChange(to newLocale: String) {
        // This will be called when the locale changes
        needsUpdate.toggle()
    }
}
```

### SwiftUI Extension

The package also includes a convenient SwiftUI view modifier:

```swift
struct ContentView: View {
    var body: some View {
        Text("Hello World")
            .onLocaleChange {
                // This will be called when the locale changes
                print("Locale changed!")
            }
    }
}
```

## Advanced Usage

### Custom Localization Configuration

You can create a custom configuration by implementing the `LocalizationConfigurationProtocol`:

```swift
struct CustomLocalizationConfiguration: LocalizationConfigurationProtocol {
    let defaultLocale: String
    let supportedLocales: [String]
    let fallbackLocale: String
    let bundleIdentifier: String
    
    // Additional custom properties and methods
}
```

### Testing

For testing purposes, you can create a mock implementation of the `LocalizationManagerProtocol`:

```swift
class MockLocalizationManager: LocalizationManagerProtocol {
    var currentLocale: String = "en"
    var configuration: LocalizationConfigurationProtocol
    
    private var observers = [LocalizationObservingProtocol]()
    
    init(configuration: LocalizationConfigurationProtocol) {
        self.configuration = configuration
    }
    
    func setLocale(_ locale: String) throws {
        currentLocale = locale
        notifyObservers(of: locale)
    }
    
    func localizedString(_ key: String, from module: String) -> String {
        return "[\(currentLocale)] \(key)"
    }
    
    func addObserver(_ observer: LocalizationObservingProtocol) {
        observers.append(observer)
    }
    
    func removeObserver(_ observer: LocalizationObservingProtocol) {
        observers.removeAll { $0 === observer }
    }
    
    private func notifyObservers(of newLocale: String) {
        observers.forEach { $0.localeDidChange(to: newLocale) }
    }
}
```

## License

This package is available under the MIT license. See the LICENSE file for more info.

## Author

Danis Preldzic