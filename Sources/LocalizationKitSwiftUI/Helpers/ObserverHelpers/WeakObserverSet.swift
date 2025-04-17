import Foundation

public final class WeakObserverSet<Observer: AnyObject> {
    private let storage: NSHashTable<AnyObject>
    
    public init() {
        self.storage = NSHashTable.weakObjects()
    }
    
    public func add(_ observer: Observer) {
        storage.add(observer)
    }
    
    public func remove(_ observer: Observer) {
        storage.remove(observer)
    }
    
    public func forEach(_ body: (Observer) -> Void) {
        for case let observer as Observer in storage.allObjects {
            body(observer)
        }
    }
} 