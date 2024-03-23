import Foundation

typealias ArkStateSetupDelegate = (ArkContext) -> Void

class ArkState {
    private(set) var arkECS: ArkECS
    private(set) var eventManager: ArkEventManager

    init(eventManager: ArkEventManager, arkECS: ArkECS) {
        self.arkECS = arkECS
        self.eventManager = eventManager
    }

    func update(deltaTime: TimeInterval) {
        arkECS.update(deltaTime: deltaTime)
        eventManager.processEvents()
    }

    func setup(_ setupDelegate: ArkStateSetupDelegate, displayContext: ArkDisplayContext) {
        let context = createActionContext(displayContext: displayContext)
        setupDelegate(context)
    }

    private func createActionContext(displayContext: ArkDisplayContext) -> ArkContext {
        ArkContext(ecs: arkECS, events: eventManager, display: displayContext)
    }
}
