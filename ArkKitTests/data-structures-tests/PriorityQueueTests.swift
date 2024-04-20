import XCTest
@testable import ArkKit

class PriorityQueueTests: XCTestCase {

    func testMaxPriorityQueue() {
        var pq = PriorityQueue<Int>(sort: >)
        pq.enqueue(1)
        pq.enqueue(3)
        pq.enqueue(2)

        XCTAssertEqual(pq.peek(), 3, "Max-priority queue should return the largest element on peek.")
        XCTAssertEqual(pq.dequeue(), 3, "Max-priority queue should return the largest element on dequeue.")
        XCTAssertFalse(pq.isEmpty, "Priority queue should not be empty after two elements remain.")
    }

    func testMinPriorityQueue() {
        var pq = PriorityQueue<Int>(sort: <)
        pq.enqueue(1)
        pq.enqueue(3)
        pq.enqueue(2)

        XCTAssertEqual(pq.peek(), 1, "Min-priority queue should return the smallest element on peek.")
        XCTAssertEqual(pq.dequeue(), 1, "Min-priority queue should return the smallest element on dequeue.")
        XCTAssertFalse(pq.isEmpty, "Priority queue should not be empty after two elements remain.")
    }

    func testIsEmptyAndCount() {
        var pq = PriorityQueue<Int>(sort: >)
        XCTAssertTrue(pq.isEmpty, "Newly created priority queue should be empty.")
        XCTAssertEqual(pq.count, 0, "Count of new priority queue should be 0.")

        pq.enqueue(1)
        pq.enqueue(2)
        XCTAssertFalse(pq.isEmpty, "Priority queue should not be empty after enqueue.")
        XCTAssertEqual(pq.count, 2, "Count should be 2 after enqueuing two items.")
    }

    func testChangePriority() {
        var pq = PriorityQueue<Int>(sort: >)
        pq.enqueue(10)
        pq.enqueue(20)
        pq.enqueue(15)

        if let index = pq.index(of: 10) {
            pq.changePriority(index: index, value: 25)
            XCTAssertEqual(pq.peek(), 25, "Change priority should update the item to become the new max.")
        } else {
            XCTFail("Index of element should be found for changePriority test.")
        }
    }

    func testQueueIndex() {
        var pq = PriorityQueue<Int>(sort: >)
        pq.enqueue(10)
        pq.enqueue(20)
        pq.enqueue(30)

        let index = pq.index(of: 20)
        XCTAssertNotNil(index, "Index of 20 should be found in the priority queue.")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        var pq = PriorityQueue<Int>(sort: >)
        self.measure {
            for i in 0..<1_000 {
                pq.enqueue(i)
            }
            for _ in 0..<1_000 {
                _ = pq.dequeue()
            }
        }
    }
}
