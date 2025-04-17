public final class AnyLocalizationObserver: LocalizationObservingProtocol {
    private let _localeDidChange: @Sendable (String) -> Void
    
    public init<T: LocalizationObservingProtocol>(_ base: T) {
        _localeDidChange = base.localeDidChange
    }
    
    public func localeDidChange(to newLocale: String) {
        _localeDidChange(newLocale)
    }
} 
