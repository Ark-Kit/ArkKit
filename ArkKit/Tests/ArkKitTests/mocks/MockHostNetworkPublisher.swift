@testable import ArkKit

class MockHostNetworkPublisher: ArkHostNetworkPublisher {
    var publishedECS: ArkECS?
    var publishedEvent: (any ArkEvent)?

    override func publish(ecs: ArkECS) {
        publishedECS = ecs
    }

    override func publish(event: any ArkEvent) {
        publishedEvent = event
    }
}
