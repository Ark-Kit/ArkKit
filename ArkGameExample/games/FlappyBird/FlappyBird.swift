import Foundation

class FlappyBird {
    private(set) var blueprint: ArkBlueprint<FlappyBirdExternalResources>
    private var characterIdToEntityMap = [Int: Entity]()

    init() {
        self.blueprint = ArkBlueprint(frameWidth: 800, frameHeight: 1_180)
        setup()
    }

    private func setup() {
        setupScene()
        setupTappableArea()
        setupRules()
        setupGameTickTracking()
        setupWallSpawner()
        cleanupWalls()
    }
}

// MARK: Setup functions
extension FlappyBird {
    private func setupRules() {
        blueprint = blueprint
            .on(FlappyBirdTapEvent.self) { event, context in
                self.handleTapEvent(event, in: context)
            }
    }

    private func setupScene() {
        blueprint = blueprint
            .setup { context in
                FlappyBirdEntityCreator.setupGroundAndSkyWalls(context: context)

                let characterEntity = FlappyBirdEntityCreator.createCharacter(context: context)
                self.characterIdToEntityMap[1] = characterEntity
            }
    }

    private func setupTappableArea() {
        blueprint = blueprint
            .setup { context in
                FlappyBirdEntityCreator.setupTappableArea(characterId: 1, context: context)
            }
    }

    private func setupGameTickTracking() {
        blueprint = blueprint
            .setup { context in
                context.ecs.createEntity(with: [
                    FlappyBirdGameTick(elapsed: 0)
                ])
            }
    }

    private func setupWallSpawner() {
        blueprint = blueprint
            .forEachTick { timeContext, actionContext in
                let ecs = actionContext.ecs
                let gameTickEntities = ecs.getEntities(with: [FlappyBirdGameTick.self])

                guard !gameTickEntities.isEmpty,
                      var gameTickComponent = ecs.getComponent(ofType: FlappyBirdGameTick.self,
                                                               for: gameTickEntities[0])
                else {
                    assertionFailure("Unable to get game tick component!")
                    return
                }

                let ticksPerSecond = 1.0 / 2
                let elapsed = timeContext.clockTimeInSecondsGame
                guard gameTickComponent.elapsed != (elapsed * ticksPerSecond).rounded() else {
                    return
                }

                // Handle tick
                FlappyBirdEntityCreator.spawnPairPipes(context: actionContext)

                gameTickComponent.elapsed += 1
                ecs.upsertComponent(gameTickComponent, to: gameTickEntities[0])
            }
    }

    /// Clean up wall entities when they exit the screen.
    private func cleanupWalls() {
        blueprint = blueprint.forEachTick { _, actionContext in
            let ecs = actionContext.ecs
            let pipeEntities = ecs.getEntities(with: [FlappyBirdPipeTag.self])

            pipeEntities.forEach { pipeEntity in
                guard let positionComponent = ecs.getComponent(ofType: PositionComponent.self, for: pipeEntity) else {
                    assertionFailure("Pipe entity does not have position component!")
                    return
                }

                guard positionComponent.position.x < -100 else {
                    return
                }

                ecs.removeEntity(pipeEntity)
            }
        }
    }
}

// MARK: Event handlers
extension FlappyBird {
    private func handleTapEvent(_ event: FlappyBirdTapEvent, in context: FlappyBirdActionContext) {
        let ecs = context.ecs
        let tapEventData = event.eventData

        guard let characterEntity = characterIdToEntityMap[tapEventData.characterId],
              var characterPhysicsComponent = ecs.getComponent(ofType: PhysicsComponent.self,
                                                               for: characterEntity)
        else {
            assertionFailure("Unable to get PhysicsComponent for character id: \(tapEventData.characterId)")
            return
        }

        // Handle character 'flying'
        characterPhysicsComponent.impulse = FlappyBirdEntityCreator.impulseValue
        ecs.upsertComponent(characterPhysicsComponent, to: characterEntity)
    }
}
