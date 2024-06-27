import XCTest
@testable import ArkKit

class QueueTests: XCTestCase {

    func testEnqueue() {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        XCTAssertEqual(queue.count, 2, "Count should be 2 after enqueuing two items.")
    }

    func testDequeue() {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        let dequeued = queue.dequeue()
        XCTAssertEqual(dequeued, 1, "The dequeued item should be the first item enqueued.")
        XCTAssertEqual(queue.count, 1, "Count should be 1 after one dequeue.")
    }

    func testPeekNil() {
        let queue = Queue<Int>()
        XCTAssertNil(queue.peek())
    }

    func testPeek() {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        let peeked = queue.peek()
        XCTAssertEqual(peeked, 1, "Peek should return the first item enqueued without removing it.")
        XCTAssertEqual(queue.count, 2, "Count should still be 2 after peek.")
    }

    func testIsEmpty() {
        var queue = Queue<Int>()
        XCTAssertTrue(queue.isEmpty, "Queue should be empty initially.")
        queue.enqueue(1)
        XCTAssertFalse(queue.isEmpty, "Queue should not be empty after enqueue.")
        _ = queue.dequeue()
        XCTAssertTrue(queue.isEmpty, "Queue should be empty after dequeueing all items.")
    }

    func testRemoveAll() {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.removeAll()
        XCTAssertTrue(queue.isEmpty, "Queue should be empty after removing all items.")
        XCTAssertEqual(queue.count, 0, "Count should be 0 after removing all items.")
    }

    func testToArray() {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        let array = queue.toArray()
        XCTAssertEqual(array, [1, 2, 3],
                       "toArray should return an array of the items in the order they would be dequeued.")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        var queue = Queue<Int>()
        self.measure {
            for i in 0..<1_000 {
                queue.enqueue(i)
            }
            for _ in 0..<1_000 {
                _ = queue.dequeue()
            }
        }
    }
}
