//
//  LocalizationManagerProtocol.swift
//  LocalizationKitSwiftUI
//
//  Created by Danis Preldzic on 17. 4. 2025..
//

public protocol LocalizationManaging: AnyObject {
    var currentLocale: String { get }
    var configuration: LocalizationConfigurationProtocol { get }
    
    func setLocale(_ locale: String) throws
    func localizedString(_ key: String, from module: String) -> String
    func addObserver(_ observer: LocalizationObservingProtocol)
    func removeObserver(_ observer: LocalizationObservingProtocol)
}
