import DequeModule

protocol SnakeGameDequeProtocol {
    associatedtype T: Hashable

    var first: T? { get }
    var last: T? { get }
    var elements: [T] { get }

    // Deque operations
    mutating func append(_ element: T)
    mutating func prepend(_ element: T)
    @discardableResult mutating func popLast() -> T?
    @discardableResult mutating func popFirst() -> T?
}

struct SnakeGameDeque<T: Hashable>: SnakeGameDequeProtocol {
    private var deque = Deque<T>()

    var first: T? { deque.first }
    var last: T? { deque.last }
    var elements: [T] {
        var copy = deque
        var result: [T] = []
        while let element = copy.popFirst() {
            result.append(element)
        }
        return result
    }

    mutating func append(_ element: T) {
        deque.append(element)
    }

    mutating func prepend(_ element: T) {
        deque.prepend(element)
    }

    @discardableResult
    mutating func popLast() -> T? {
        guard let element = deque.popLast() else {
            return nil
        }
        return element
    }

    @discardableResult
    mutating func popFirst() -> T? {
        guard let element = deque.popFirst() else {
            return nil
        }
        return element
    }
}
