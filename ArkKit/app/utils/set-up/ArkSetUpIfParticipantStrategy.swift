struct ArkSetUpIfParticipantStrategy<View, ExternalResources: ArkExternalResources>: ArkSetUpStrategy {
    weak var ark: Ark<View, ExternalResources>?

    func setUp() {
        guard let ark = ark,
              let networkPlayableInfo = ark.blueprint.networkPlayableInfo,
              networkPlayableInfo.role == .participant else {
            return
        }
        setupDefaultListeners()
        setupMultiplayerGameLoop()
        setup(ark.blueprint.setupFunctions)
        setup(ark.blueprint.soundMapping)

        let networkService = ArkNetworkService(serviceName: networkPlayableInfo.roomName)
        ark.participantSubscriber = ArkParticipantNetworkSubscriber(subscribeTo: networkService)
        ark.participantSubscriber?.localState = ark.arkState
        ark.participantSubscriber?.localGameLoop = ark.gameLoop

        let participantPublisher = ArkParticipantNetworkPublisher(publishTo: networkService)
        ark.arkState.eventManager.networkPublisherDelegate = participantPublisher

        preserveSelectComponentsIfParticipant()
    }

    private func preserveSelectComponentsIfParticipant() {
        // Retrieve all entities
        let allEntities = ark?.arkState.arkECS.getEntities() ?? []

        // Filter and preserve entities with renderable components at the screen layer
        var preservedEntityToRenderableComponent: [Entity: [any RenderableComponent]] = [:]
        for entity in allEntities {
            preserveRenderableComponentsAtScreenLayer(for: entity, in: &preservedEntityToRenderableComponent)
        }

        // Remove all other entities
        let preservedEntities = Array(preservedEntityToRenderableComponent.keys)
        ark?.arkState.arkECS.removeAllEntities(except: preservedEntities)

        // Bulk upsert the preserved entities and their components
        var preservedComponentMapping: [EntityID: [any Component]] = [:]
        preservedEntityToRenderableComponent.forEach { entity, componentList in
            preservedComponentMapping[entity.id] = componentList
        }
        ark?.arkState.arkECS.bulkUpsert(entities: preservedEntities, components: preservedComponentMapping)
    }

    private func preserveRenderableComponentsAtScreenLayer(
        for entity: Entity,
        in preservedEntityToRenderableComponent: inout [Entity: [any RenderableComponent]]
    ) {
        for renderableComponentType in ArkCanvasSystem.renderableComponentTypes {
            if let renderableComponent = ark?.arkState.arkECS.getComponent(ofType: renderableComponentType, for: entity),
               renderableComponent.renderLayer == .screen {
                if preservedEntityToRenderableComponent[entity] == nil {
                    preservedEntityToRenderableComponent[entity] = []
                }
                preservedEntityToRenderableComponent[entity]?.append(renderableComponent)
            }
        }
    }
}
