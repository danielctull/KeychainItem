
@propertyWrapper
public final class Keychain<Value> {

    public let item: KeychainItem<Value>

    public init(_ item: KeychainItem<Value>) {
        self.item = item
    }

    public var wrappedValue: Value? {
        get { try? Keychain.value(for: item) }
        set { try? Keychain.setValue(newValue, for: item) }
    }
}
