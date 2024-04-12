import DequeModule

protocol SnakeGameDequeProtocol {
    associatedtype T

    var first: T? { get }
    var last: T? { get }

    mutating func append(_ element: T)
    mutating func prepend(_ element: T)
    @discardableResult mutating func popLast() -> T?
    @discardableResult mutating func popFirst() -> T?
}

struct SnakeGameDeque<T>: SnakeGameDequeProtocol {
    private var deque = Deque<T>()

    var first: T? { deque.first }
    var last: T? { deque.last }

    mutating func append(_ element: T) {
        deque.append(element)
    }

    mutating func prepend(_ element: T) {
        deque.prepend(element)
    }

    @discardableResult
    mutating func popLast() -> T? {
        deque.popLast()
    }

    @discardableResult
    mutating func popFirst() -> T? {
        deque.popFirst()
    }
}
