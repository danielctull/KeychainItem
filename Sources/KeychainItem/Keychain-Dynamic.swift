
#if canImport(Combine) && canImport(SwiftUI)

import Combine
import SwiftUI

private final class Observable<Value>: ObservableObject {

    let item: KeychainItem<Value>
    init(item: KeychainItem<Value>) {
        self.item = item
    }

    var value: Value? {
        get { try? Keychain.value(for: item) }
        set { try? Keychain.setValue(newValue, for: item) }
    }

    var objectWillChange: AnyPublisher<KeychainItem<Value>, Never> {
        let item = self.item
        return NotificationCenter.default
            .publisher(for: .keychainItemWillChange)
            .catch { _ in Empty<Notification, Never>() }
            .compactMap { $0.object as? KeychainItem<Value> }
            .filter { $0.account == item.account }
            .filter { $0.accessGroup == item.accessGroup }
            .eraseToAnyPublisher()
    }
}

@propertyWrapper
public struct Keychain<Value>: DynamicProperty {

    public let item: KeychainItem<Value>
    @ObservedObject private var observable: Observable<Value>

    public init(_ item: KeychainItem<Value>) {
        self.item = item
        observable = Observable(item: item)
    }

    /// The value stored in the keychain for the given key.
    public var wrappedValue: Value? {
        get { observable.value }
        nonmutating set { observable.value = newValue }
    }

    /// A binding to the value in stored in the keychain.
    public var projectedValue: Binding<Value?> { $observable.value }
}

#endif
