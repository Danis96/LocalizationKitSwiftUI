//
//  LocalizationConfImplementation.swift
//  LocalizationKitSwiftUI
//
//  Created by Danis Preldzic on 17. 4. 2025..
//

public struct DefaultLocalizationConfiguration: LocalizationConfigurationProtocol, Sendable {
    
    public static let shared = DefaultLocalizationConfiguration(
        defaultLocale: "en",
        supportedLocales: ["en"],
        fallbackLocale: "en",
        bundleIdentifier: ""
    )
    
    public let defaultLocale: String
    public let supportedLocales: [String]
    public let fallbackLocale: String
    public let bundleIdentifier: String
    
    public init(
        defaultLocale: String = "en",
        supportedLocales: [String],
        fallbackLocale: String = "en",
        bundleIdentifier: String
    ) {
        self.defaultLocale = defaultLocale
        self.supportedLocales = supportedLocales
        self.fallbackLocale = fallbackLocale
        self.bundleIdentifier = bundleIdentifier
    }
}
