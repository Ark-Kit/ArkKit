/**
 * Preserves order of elements by insertion order.
 */
struct OrderedDictionary<Key: Hashable, Value>: Sequence {
    private var dictionary: [Key: Value] = [:]
    private var keys: [Key] = []

    mutating func insert(_ value: Value, forKey key: Key) {
        if dictionary[key] == nil {
            keys.append(key)
        }
        dictionary[key] = value
    }

    func value(forKey key: Key) -> Value? {
        dictionary[key]
    }

    subscript(key: Key) -> Value? {
        get {
            value(forKey: key)
        }
        set {
            if let value = newValue {
                insert(value, forKey: key)
            } else {
                removeValue(forKey: key)
            }
        }
    }

    mutating func removeValue(forKey key: Key) {
        guard let index = keys.firstIndex(of: key) else {
            return
        }
        keys.remove(at: index)
        dictionary[key] = nil
    }

    var count: Int {
        keys.count
    }

    func makeIterator() -> AnyIterator<(Key, Value)> {
        var index = 0
        return AnyIterator {
            guard index < self.keys.count else {
                return nil
            }
            defer {
                index += 1
            }
            let key = self.keys[index]
            let value = self.dictionary[key]!
            return (key, value)
        }
    }
}
