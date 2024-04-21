import XCTest
@testable import ArkKit

class OrderedDictionaryTests: XCTestCase {

    func testInsertAndValueRetrieval() {
        var orderedDict = OrderedDictionary<String, Int>()
        orderedDict.insert(1, forKey: "one")
        orderedDict.insert(2, forKey: "two")

        XCTAssertEqual(orderedDict.value(forKey: "one"), 1, "The value for 'one' should be 1.")
        XCTAssertEqual(orderedDict.value(forKey: "two"), 2, "The value for 'two' should be 2.")
        XCTAssertEqual(orderedDict.count, 2, "The count should be 2 after inserting two different keys.")
    }

    func testSubscript() {
        var orderedDict = OrderedDictionary<String, Int>()
        orderedDict["one"] = 1
        orderedDict["two"] = 2
        orderedDict["one"] = 11

        XCTAssertEqual(orderedDict["one"], 11, "The value for 'one' should be updated to 11.")
        XCTAssertEqual(orderedDict["two"], 2, "The value for 'two' should remain 2.")
        XCTAssertEqual(orderedDict.count, 2, "The count should remain 2 after updating an existing key.")
    }

    func testRemoveValue() {
        var orderedDict = OrderedDictionary<String, Int>()
        orderedDict.insert(1, forKey: "one")
        orderedDict.insert(2, forKey: "two")
        orderedDict.removeValue(forKey: "one")

        XCTAssertNil(orderedDict["one"], "The value for 'one' should be nil after removal.")
        XCTAssertEqual(orderedDict.count, 1, "The count should be 1 after removing one of the two keys.")
    }

    func testOrderPreservation() {
        var orderedDict = OrderedDictionary<String, Int>()
        orderedDict.insert(1, forKey: "one")
        orderedDict.insert(2, forKey: "two")
        orderedDict.insert(3, forKey: "three")

        var iteratedKeys: [String] = []
        for (key, _) in orderedDict {
            iteratedKeys.append(key)
        }

        XCTAssertEqual(iteratedKeys, ["one", "two", "three"],
                       "Keys should be iterated in the order they were inserted.")
    }

    func testPerformanceExample() {
        var orderedDict = OrderedDictionary<Int, Int>()
        self.measure {
            for i in 0..<1_000 {
                orderedDict.insert(i, forKey: i)
            }
            for key in 0..<1_000 {
                _ = orderedDict[key]
            }
            for key in 0..<1_000 {
                orderedDict.removeValue(forKey: key)
            }
        }
    }
}
