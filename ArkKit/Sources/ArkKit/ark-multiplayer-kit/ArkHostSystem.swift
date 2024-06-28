import Foundation

class ArkHostSystem: UpdateSystem {
    let publisher: ArkHostNetworkPublisher
    var active: Bool

    init(publisher: ArkHostNetworkPublisher, active: Bool = true) {
        self.publisher = publisher
        self.active = active
    }

    func update(deltaTime: TimeInterval, arkECS: ArkECS) {
        publisher.publish(ecs: arkECS)
    }
}
