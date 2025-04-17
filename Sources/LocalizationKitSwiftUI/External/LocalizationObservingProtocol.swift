//
//  LocalizationObservingProtocol.swift
//  LocalizationKitSwiftUI
//
//  Created by Danis Preldzic on 17. 4. 2025..
//

public protocol LocalizationObservingProtocol: AnyObject {
    func localeDidChange(to newLocale: String)
}
