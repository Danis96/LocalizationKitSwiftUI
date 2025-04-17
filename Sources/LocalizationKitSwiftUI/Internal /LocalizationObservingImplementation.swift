//
//  LocalizationObservingImplementation.swift
//  LocalizationKitSwiftUI
//
//  Created by Danis Preldzic on 17. 4. 2025..
//

import SwiftUI
import Factory

private final class ViewLocalizationObserver: LocalizationObservingProtocol, ObservableObject, @unchecked Sendable {
    var action: (() -> Void)?
    
    func localeDidChange(to newLocale: String) {
        self.action?()
    }
}

public extension View {
    func onLocaleChange(_ action: @escaping () -> Void) -> some View {
        modifier(LocalizationObservingViewModifier(action: action))
    }
}

public struct LocalizationObservingViewModifier: ViewModifier {
    @StateObject private var observer = ViewLocalizationObserver()
    private let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                observer.action = action
                LocalizationKitSwiftUI.shared.localizationManager
                    .addObserver(observer)
            }
            .onDisappear {
                LocalizationKitSwiftUI.shared.localizationManager
                    .removeObserver(observer)
            }
    }
}

