import Foundation

typealias ArkStateSetupDelegate = (ArkSetupContext) -> Void

class ArkState {
    private(set) var arkECS: ArkECS
    private(set) var eventManager: ArkEventManager

    init(eventManager: ArkEventManager, arkECS: ArkECS) {
        self.arkECS = arkECS
        self.eventManager = eventManager
    }

    func update(deltaTime: TimeInterval) {
        eventManager.processEvents()
        arkECS.update(deltaTime: deltaTime)
    }

    func setup(_ setupDelegate: ArkStateSetupDelegate, displayContext: ArkDisplayContext) {
        let context = createActionContext(displayContext: displayContext)
        setupDelegate(context)
    }

    private func createActionContext(displayContext: ArkDisplayContext) -> ArkSetupContext {
        ArkSetupContext(ecs: arkECS, events: eventManager, display: displayContext)
    }
}
