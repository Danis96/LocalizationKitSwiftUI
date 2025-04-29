// The Swift Programming Language
// https://docs.swift.org/swift-book

import Factory


final public class LocalizationKitSwiftUI: SharedContainer {
    public let manager = ContainerManager()
    public static let shared = LocalizationKitSwiftUI()
}


public extension LocalizationKitSwiftUI {
    var networkManager: Factory<LocalizationConfigurationProtocol> {
        self { DefaultLocalizationConfiguration.shared }
            .singleton
    }
}
