//
//  LocalizationConfigurationProtocol.swift
//  LocalizationKitSwiftUI
//
//  Created by Danis Preldzic on 17. 4. 2025..
//

public protocol LocalizationConfigurationProtocol {
    var defaultLocale: String { get }
    var supportedLocales: [String] { get }
    var fallbackLocale: String { get }
    var bundleIdentifier: String { get }
}
