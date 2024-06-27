class ArkSetUpWithoutNetwork<View, ExternalResources: ArkExternalResources>: ArkSetUpStrategy {
    weak var ark: Ark<View, ExternalResources>?

    init(ark: Ark<View, ExternalResources>? = nil) {
        self.ark = ark
    }

    func setUp() {
        guard let ark = ark,
              ark.blueprint.networkPlayableInfo?.role != .participant else {
            return
        }
        setupDefaultEntities()
        setupDefaultListeners()
        setupDefaultSystems(ark.blueprint)
        setup(ark.blueprint.setupFunctions)
        setup(ark.blueprint.rules)
        setup(ark.blueprint.soundMapping)

        // add playersetup functions if no network
        if ark.blueprint.networkPlayableInfo == nil {
            setup(ark.blueprint.playerSpecificSetupFunctions)
        }
    }
}
