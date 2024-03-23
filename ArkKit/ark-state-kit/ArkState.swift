import Foundation

typealias ArkStateSetupDelegate = (ArkActionContext) -> Void

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
    
    private func createActionContext(displayContext: ArkDisplayContext) -> ArkActionContext {
        ArkActionContext(ecs: arkECS, events: eventManager, display: displayContext)
    }
}
