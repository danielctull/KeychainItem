
@propertyWrapper
public final class Keychain<Value> {

    public let item: KeychainItem<Value>

    public init(_ item: KeychainItem<Value>) {
        self.item = item
    }

    public var wrappedValue: Value? {
        get { try? value(for: item) }
        set { try? setValue(newValue, for: item) }
    }
}
