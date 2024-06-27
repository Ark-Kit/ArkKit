import Foundation

typealias ArkEventTypeIdentifier = ObjectIdentifier

public protocol ArkEvent<Data> {
    associatedtype Data = ArkEventData

    var eventData: Data { get }
    var priority: Int? { get set }
}
