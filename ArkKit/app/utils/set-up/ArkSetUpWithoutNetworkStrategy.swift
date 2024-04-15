struct ArkSetUpWithoutNetwork<View, ExternalResources: ArkExternalResources>: ArkSetUpStrategy {
    weak var ark: Ark<View, ExternalResources>?

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
    }
}
