//
//  LocalizationManagerImplementation.swift
//  LocalizationKitSwiftUI
//
//  Created by Danis Preldzic on 17. 4. 2025..
//

import SQAUtility
import Factory
import SwiftUI

public final class LocalizationManagerImplementation: LocalizationManagerProtocol, @unchecked Sendable {
    
    @MainActor public static let shared = LocalizationManagerImplementation(
        configuration: DefaultLocalizationConfiguration(
            supportedLocales: ["en"],
            bundleIdentifier: Bundle.main.bundleIdentifier ?? ""
        )
    )
    
    @Injected(\SQAUtility.storageManager) private var storageManager: StorageManager
    
    private final class Observer: LocalizationObservingProtocol {
        private let callback: @MainActor (String) -> Void
        private let base: (any LocalizationObservingProtocol)?
        
        init(_ base: any LocalizationObservingProtocol) {
            self.base = base
            self.callback = base.localeDidChange
        }
        
        func localeDidChange(to newLocale: String) {
            Task { @MainActor in
                callback(newLocale)
            }
        }
        
        func isWrapping(_ observer: LocalizationObservingProtocol) -> Bool {
            return base === observer
        }
        
        static func == (lhs: Observer, rhs: Observer) -> Bool {
            lhs.base === rhs.base
        }
    }
    
    private let observers: WeakObserverSet<Observer>
    public let configuration: LocalizationConfigurationProtocol
    
    public init(
        configuration: LocalizationConfigurationProtocol
    ) {
        self.configuration = configuration
        self.observers = WeakObserverSet()
    }
    
    public var currentLocale: String {
        get {
            return storageManager.getLanguage()
        }
    }
    
    public func setLocale(_ locale: String) throws {
        guard configuration.supportedLocales.contains(locale) else {
            throw LocalizationError.unsupportedLocale(locale)
        }
        
        storageManager.setLanguage(locale)
        notifyObservers(of: locale)
    }
    
    public func localizedString(_ key: String, from module: String) -> String {
        let bundle = Bundle(identifier: "\(configuration.bundleIdentifier).\(module)") ?? .main
        
        // Try current locale
        let localizedString = bundle.localizedString(
            forKey: key,
            value: nil,
            table: module
        )
        if localizedString != key {
            return localizedString
        }
        
        // Try fallback locale
        if currentLocale != configuration.fallbackLocale,
           let bundlePath = bundle.path(
            forResource: configuration.fallbackLocale,
            ofType: "lproj"
           ),
           let fallbackBundle = Bundle(path: bundlePath) {
            return fallbackBundle.localizedString(forKey: key, value: key, table: module)
        }
        
        return key
    }
    
    public func addObserver(_ observer: LocalizationObservingProtocol) {
        observers.add(Observer(observer))
    }
    
    public func removeObserver(_ observer: LocalizationObservingProtocol) {
        observers.forEach { wrappedObserver in
            if wrappedObserver.isWrapping(observer) {
                observers.remove(wrappedObserver)
            }
        }
    }
    
    private func notifyObservers(of newLocale: String) {
        observers.forEach { observer in
            observer.localeDidChange(to: newLocale)
        }
    }
}
