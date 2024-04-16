class ArkSetUpIfParticipantStrategy<View, ExternalResources: ArkExternalResources>: ArkSetUpStrategy {
    weak var ark: Ark<View, ExternalResources>?

    init(ark: Ark<View, ExternalResources>? = nil) {
        self.ark = ark
    }

    func setUp() {
        guard let ark = ark,
              let networkPlayableInfo = ark.blueprint.networkPlayableInfo,
              networkPlayableInfo.role == .participant else {
            return
        }
        setupDefaultListeners()
        setupMultiplayerGameLoop()
        let dummyECS = ArkECS()
        setup(ark.blueprint.setupFunctions, with: ArkSetupContext(
            ecs: dummyECS,
            events: ark.arkState.eventManager,
            display: ark.displayContext)
        )
        setup(ark.blueprint.rules, with: ArkActionContext(
            ecs: dummyECS,
            events: ark.arkState.eventManager,
            display: ark.displayContext,
            audio: ark.audioContext
        ))
        // filter for screen resize rules
        let screenResizeRules = ark.blueprint.rules.filter { rule in
            guard let castedRule = rule as? any Rule<RuleEventType>,
                  let _ = castedRule.trigger.eventType as? ScreenResizeEvent.Type
            else {
                return false
            }

            return true
        }
        setup(screenResizeRules)
        setup(ark.blueprint.soundMapping)

        let networkService = ArkNetworkService(serviceName: networkPlayableInfo.roomName)
        ark.networkService = networkService
        ark.participantSubscriber = ArkParticipantNetworkSubscriber(subscribeTo: networkService)
        ark.participantSubscriber?.localState = ark.arkState
        ark.participantSubscriber?.localGameLoop = ark.gameLoop
        ark.participantSubscriber?.playerStateSetUpDelegate = self

        let participantPublisher = ArkParticipantNetworkPublisher(publishTo: networkService)
        ark.arkState.eventManager.networkPublisherDelegate = participantPublisher
    }
}

extension ArkSetUpIfParticipantStrategy: ArkPlayerStateSetupDelegate {
    func setup(_ playerId: Int) {
        let playerSetUpCallbacks = ark?.blueprint.playerSpecificSetupFunctions
        guard playerId < playerSetUpCallbacks?.count ?? 0,
              let specificPlayerSetUp = playerSetUpCallbacks?[playerId],
              let ark = ark else {
            return
        }
        ark.arkState.setup(specificPlayerSetUp, with: ark.setupContext)
    }
}
