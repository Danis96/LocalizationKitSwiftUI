//
//  ErrorHandling.swift
//  LocalizationKitSwiftUI
//
//  Created by Danis Preldzic on 17. 4. 2025..
//

import Foundation


public enum LocalizationError: Error {
    case unsupportedLocale(String)
    case storageError(Error)
}

extension LocalizationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .unsupportedLocale(let locale):
                return "Locale '\(locale)' is not supported"
            case .storageError(let error):
                return "Storage error: \(error.localizedDescription)"
        }
    }
}
