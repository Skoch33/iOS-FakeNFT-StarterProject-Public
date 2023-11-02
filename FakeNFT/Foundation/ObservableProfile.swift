import Foundation

@propertyWrapper
final class ObservableProfile<Value> {
    private var observers: [(Value) -> Void] = []

    var wrappedValue: Value {
        didSet {
            for observer in observers {
                observer(wrappedValue)
            }
        }
    }

    var projectedValue: ObservableProfile<Value> {
        return self
    }

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    func observe(_ observer: @escaping (Value) -> Void) {
        observers.append(observer)
        observer(wrappedValue)
    }
}