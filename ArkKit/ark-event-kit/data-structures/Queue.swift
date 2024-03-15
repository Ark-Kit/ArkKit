//
//  Queue.swift
//  ArkKit
//
//  Created by Ryan Peh on 14/3/24.
//

struct Queue<T> {
    private var enqueueArray: [T] = []
    private var dequeueArray: [T] = []

    /// Adds an element to the tail of the queue.
    /// - Parameter item: The element to be added to the queue
    mutating func enqueue(_ item: T) {
        enqueueArray.append(item)
    }

    /// Removes an element from the head of the queue and return it.
    /// - Returns: item at the head of the queue
    mutating func dequeue() -> T? {
        if !dequeueArray.isEmpty {
            return dequeueArray.popLast()
        }
        while let element = enqueueArray.popLast() {
            dequeueArray.append(element)
        }
        return dequeueArray.popLast()
    }

    /// Returns, but does not remove, the element at the head of the queue.
    /// - Returns: item at the head of the queue
    func peek() -> T? {
        if !dequeueArray.isEmpty {
            return dequeueArray.last
        } else {
            return enqueueArray.first
        }
    }

    /// The number of elements currently in the queue.
    var count: Int {
        dequeueArray.count + enqueueArray.count
    }

    /// Whether the queue is empty.
    var isEmpty: Bool {
        dequeueArray.isEmpty && enqueueArray.isEmpty
    }

    /// Removes all elements in the queue.
    mutating func removeAll() {
        dequeueArray.removeAll()
        enqueueArray.removeAll()
    }

    /// Returns an array of the elements in their respective dequeue order, i.e.
    /// first element in the array is the first element to be dequeued.
    /// - Returns: array of elements in their respective dequeue order
    func toArray() -> [T] {
        dequeueArray.reversed() + enqueueArray
    }
}
