import DequeModule

protocol SnakeGameDequeProtocol {
    associatedtype T: Hashable

    var first: T? { get }
    var last: T? { get }

    // Deque operations
    mutating func append(_ element: T)
    mutating func prepend(_ element: T)
    @discardableResult mutating func popLast() -> T?
    @discardableResult mutating func popFirst() -> T?

    // O(1) set contains operation
    func contains(_ element: T) -> Bool
}

struct SnakeGameDeque<T: Hashable>: SnakeGameDequeProtocol {
    private var deque = Deque<T>()
    private var hashMap: [T: Int] = [:]

    var first: T? { deque.first }
    var last: T? { deque.last }

    mutating func append(_ element: T) {
        deque.append(element)
        incrementHashMap(value: element)
    }

    mutating func prepend(_ element: T) {
        deque.prepend(element)
        incrementHashMap(value: element)
    }

    @discardableResult
    mutating func popLast() -> T? {
        guard let element = deque.popLast() else {
            return nil
        }
        decrementHashMap(value: element)
        return element
    }

    @discardableResult
    mutating func popFirst() -> T? {
        guard let element = deque.popFirst() else {
            return nil
        }
        decrementHashMap(value: element)
        return element
    }

    func contains(_ element: T) -> Bool {
        hashMap[element] != nil
    }
}

// MARK: Helpers
extension SnakeGameDeque {
    mutating func incrementHashMap(value: T) {
        hashMap[value] = hashMap[value] ?? 0 + 1
    }

    mutating func decrementHashMap(value: T) {
        hashMap[value] = hashMap[value] ?? 0 - 1
        if hashMap[value] ?? 0 <= 0 {
            hashMap[value] = nil
        }
    }
}
