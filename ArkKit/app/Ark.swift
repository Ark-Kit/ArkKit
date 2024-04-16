import Foundation

/**
 * `Ark` describes the game as is **loaded**.
 *
 * It loads the various contexts from the  `ArkBlueprint` provided and the `GameLoop`.
 * `Ark` requires a `rootView: AbstractRootView` to render the game.
 *
 * `Ark.start()` starts a loaded version of the game by injecting the game context dependencies.
 *
 * User of the `Ark` instance should ensure that the `arkInstance` is **binded** (strongly referenced), otherwise events
 * relying on the `arkInstance` will not emit.
 */
class Ark<View, ExternalResources: ArkExternalResources>: ArkProtocol {
    let rootView: any AbstractRootView<View>
    var arkState: ArkState
    var gameLoop: GameLoop?

    let blueprint: ArkBlueprint<ExternalResources>
    let audioContext: any AudioContext<ExternalResources.AudioEnum>
    var displayContext: DisplayContext

    var actionContext: ArkActionContext<ExternalResources> {
        ArkActionContext(ecs: arkState.arkECS,
                         events: arkState.eventManager,
                         display: displayContext,
                         audio: audioContext)
    }

    var setupContext: ArkSetupContext {
        ArkSetupContext(ecs: arkState.arkECS, events: arkState.eventManager, display: displayContext)
    }

    var canvasRenderableBuilder: (any RenderableBuilder<View>)?

    // network dependencies
    var participantSubscriber: ArkParticipantNetworkSubscriber?
    var hostSubscriber: ArkHostNetworkSubscriber?
    var networkService: ArkNetworkService?

    init(rootView: any AbstractRootView<View>,
         blueprint: ArkBlueprint<ExternalResources>,
         canvasRenderableBuilder: (any RenderableBuilder<View>)? = nil) {
        self.rootView = rootView
        self.blueprint = blueprint

        let eventManager = ArkEventManager()
        let ecsManager = ArkECS()
        self.arkState = ArkState(eventManager: eventManager, arkECS: ecsManager)

        self.audioContext = ArkAudioContext()
        self.canvasRenderableBuilder = canvasRenderableBuilder
        self.displayContext = ArkDisplayContext(
            canvasSize: CGSize(
                width: blueprint.frameWidth,
                height: blueprint.frameHeight
            ),
            screenSize: rootView.size
        )
    }

    func start() {
        ArkSetUpOrchestrator(ark: self).executeSetUp()
        alignCamera()

        guard let gameLoop = self.gameLoop else {
            return
        }

        let gameCoordinator = ArkGameCoordinator<View>(rootView: rootView,
                                                       arkState: arkState,
                                                       displayContext: displayContext,
                                                       gameLoop: gameLoop,
                                                       canvasRenderer: canvasRenderableBuilder)
        gameCoordinator.start()
    }

    func finish() {
        networkService?.disconnect()
        gameLoop?.shutDown()
    }

    private func alignCamera() {
        let cameraEntities = arkState.arkECS.getEntities(with: [PlacedCameraComponent.self])
        if !cameraEntities.isEmpty {
            return
        }
        arkState.arkECS.createEntity(with: [PlacedCameraComponent(
            camera: Camera(
                canvasPosition: CGPoint(
                    x: displayContext.canvasSize.width / 2,
                    y: displayContext.canvasSize.height / 2
                ),
                zoom: 1.0
            ),
            screenPosition: CGPoint(
                x: displayContext.screenSize.width / 2,
                y: displayContext.screenSize.height / 2
            ),
            size: displayContext.screenSize)
        ])
    }
}

extension ArkEvent {
    /// A workaround to prevent weird behavior when trying to execute
    /// `action.execute(event, context: context)`
    func executeAction<ExternalResources: ArkExternalResources>(_ action: some Action,
                                                                context: ArkActionContext<ExternalResources>) {
        guard let castedAction = action as? any Action<Self, ExternalResources> else {
            return
        }

        castedAction.execute(self, context: context)
    }
}
