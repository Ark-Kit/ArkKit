import Foundation

typealias ArkStateSetupDelegate = (ArkSetupContext) -> Void

class ArkState {
    private(set) var arkECS: ArkECS
    private(set) var eventManager: ArkEventManager

    init(eventManager: ArkEventManager, arkECS: ArkECS) {
        self.arkECS = arkECS
        self.eventManager = eventManager
    }

    func startUp() {
        arkECS.startUp()
    }

    func update(deltaTime: TimeInterval) {
        eventManager.processEvents()
        arkECS.update(deltaTime: deltaTime)
    }

    func cleanUp() {
        arkECS.cleanUp()
    }

    func setup(_ setupDelegate: ArkStateSetupDelegate,
               with setUpContext: ArkSetupContext) {
        let context = setUpContext
        setupDelegate(context)
    }

    private func createActionContext(displayContext: DisplayContext) -> ArkSetupContext {
        ArkSetupContext(ecs: arkECS, events: eventManager, display: displayContext)
    }
}
