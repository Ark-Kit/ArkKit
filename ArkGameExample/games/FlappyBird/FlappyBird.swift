import Foundation
import UIKit

class FlappyBird {
    private(set) var blueprint: ArkBlueprint<FlappyBirdExternalResources>
    var collisionStrategyManager = FlappyBirdCollisionStrategyManager()
    var rootView: AbstractDemoGameHostingPage

    init(rootView: AbstractDemoGameHostingPage) {
        self.blueprint = ArkBlueprint<FlappyBirdExternalResources>(frameWidth: 800, frameHeight: 1_180)
        self.rootView = rootView
        setup()
    }

    private func setup() {
        setupScene()
        setupTappableArea()
        setupRules()
        setupGameTickTracking()
        setupWallSpawner()
        cleanupWalls()
        setupWinLoseConditions()
    }
}

// MARK: Setup functions
extension FlappyBird {
    private func setupRules() {
        blueprint = blueprint
            .on(FlappyBirdTapEvent.self) { event, context in
                self.handleTapEvent(event, in: context)
            }
            .on(ArkCollisionBeganEvent.self) { event, context in
                self.handleContactBegan(event, in: context)
            }
            .on(ArkCollisionEndedEvent.self) { event, context in
                self.handleContactEnd(event, in: context)
            }
            .on(FlappyBirdWallHitEvent.self) { event, context in
                self.handleWallHit(event, in: context)
            }
            .on(FlappyBirdPipePassEvent.self) { event, context in
                self.handlePipePass(event, in: context)
            }
            .forEachTick { timeContext, context in
                // increase the game speed

                guard let gameSpeedEntity = context.ecs.getEntities(with: [FlappyBirdGameSpeed.self]).first else {
                    return
                }

                guard var gameSpeed = context.ecs.getComponent(
                    ofType: FlappyBirdGameSpeed.self, for: gameSpeedEntity) else {
                    return
                }

                // Take about 2 minutes to ramp up to speed = 1 to speed = 3
                let speedPercentage = min(1, timeContext.clockTimeInSecondsGame / 120)
                let newSpeed = (speedPercentage * 2) + 1

                gameSpeed.speed = newSpeed

                context.ecs.upsertComponent(gameSpeed, to: gameSpeedEntity)
            }
    }

    private func handlePipePass(_ event: FlappyBirdPipePassEvent, in context: FlappyBirdActionContext) {
        let characterId = event.eventData.characterId
        let scoreEntity = context.ecs.getEntities(with: [FlappyBirdScore.self]).first

        guard let scoreEntity else {
            assertionFailure("Unable to get score-tracking entity")
            return
        }

        guard var scoreComponent = context.ecs.getComponent(ofType: FlappyBirdScore.self, for: scoreEntity) else {
            assertionFailure("Unable to get score component for score entity")
            return
        }

        let oldScore = scoreComponent.scores[characterId] ?? 0
        let newScore = oldScore + 1
        scoreComponent.setScore(newScore, forId: characterId)
        context.ecs.upsertComponent(scoreComponent, to: scoreEntity)

        guard let scoreTextEntity = context.ecs.getEntities(with: [FlappyBirdScoreLabelTag.self]).first(where: {
            let cId = context.ecs.getComponent(ofType: FlappyBirdScoreLabelTag.self, for: $0)?.characterId

            return cId == characterId
        }) else {
            assertionFailure("Unable to get score text entity")
            return
        }

        guard let scoreLabelComponent = context.ecs.getComponent(ofType: RectRenderableComponent.self,
                                                                 for: scoreTextEntity)?.label(String(newScore)) else {
            assertionFailure("Unable to get score label component")
            return
        }

        context.ecs.upsertComponent(scoreLabelComponent, to: scoreTextEntity)
    }

    private func handleWallHit(_ event: FlappyBirdWallHitEvent, in context: FlappyBirdActionContext) {
        let characterId = event.eventData.characterId
        let characterEntity = context.ecs.getEntities(with: [FlappyBirdCharacterTag.self])
            .first {
                context.ecs.getComponent(ofType: FlappyBirdCharacterTag.self, for: $0)?.characterId == characterId
            }

        guard let characterEntity else {
            assertionFailure("Unable to get character entity for characterId: \(characterId)")
            return
        }

        context.ecs.removeEntity(characterEntity)
    }

    private func handleContactBegan(_ event: ArkCollisionBeganEvent, in context: FlappyBirdActionContext) {
        let eventData = event.eventData

        let entityA = eventData.entityA
        let entityB = eventData.entityB
        let bitMaskA = eventData.entityACategoryBitMask
        let bitMaskB = eventData.entityBCategoryBitMask

        collisionStrategyManager.handleCollisionBegan(between: entityA, and: entityB,
                                                      bitMaskA: bitMaskA, bitMaskB: bitMaskB,
                                                      in: context)
    }

    private func handleContactEnd(_ event: ArkCollisionEndedEvent, in context: FlappyBirdActionContext) {
        let eventData = event.eventData

        let entityA = eventData.entityA
        let entityB = eventData.entityB
        let bitMaskA = eventData.entityACategoryBitMask
        let bitMaskB = eventData.entityBCategoryBitMask

        collisionStrategyManager.handleCollisionEnded(between: entityA, and: entityB,
                                                      bitMaskA: bitMaskA, bitMaskB: bitMaskB,
                                                      in: context)
    }

    private func setupScene() {
        blueprint = blueprint
            .setup { context in
                context.ecs.createEntity(with: [FlappyBirdGameSpeed()])
                FlappyBirdEntityCreator.createBackground(context: context)
                FlappyBirdEntityCreator.setGravity(context: context)
                FlappyBirdEntityCreator.spawnBase(context: context)
                FlappyBirdEntityCreator.spawnCeiling(context: context)
                FlappyBirdEntityCreator.createCharacter(context: context, characterId: 1)
                FlappyBirdEntityCreator.initializeScore(context: context, characterIds: [1])
            }
            .forEachTick { _, context in
                let characters = context.ecs.getEntities(with: [FlappyBirdCharacterTag.self])

                for character in characters {
                    guard context.ecs.getComponent(ofType: RotationComponent.self, for: character) != nil,
                          let physicsComponent
                            = context.ecs.getComponent(ofType: PhysicsComponent.self, for: character),
                          var bitmapImageComponent
                            = context.ecs.getComponent(ofType: BitmapImageRenderableComponent.self, for: character)
                    else {
                        continue
                    }

                    let downwardSpeed = physicsComponent.velocity.dy
                    let rotationRadians = max(min(downwardSpeed / 300, 1.0), -1.0) * .pi / 8
                    bitmapImageComponent.rotation = rotationRadians

                    let midflapThresholdSpeed = 100.0

                    var imageResource: FlappyBirdImage {
                        if abs(downwardSpeed) <= midflapThresholdSpeed {
                            return FlappyBirdImage.characterMidflap
                        }

                        if downwardSpeed > 0 {
                            return FlappyBirdImage.characterUpflap
                        }

                        return FlappyBirdImage.characterDownflap

                    }

                    bitmapImageComponent.imageResourcePath = imageResource.rawValue

                    context.ecs.upsertComponent(bitmapImageComponent, to: character)
                }
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

                guard let gameSpeedEntity = ecs.getEntities(with: [FlappyBirdGameSpeed.self]).first else {
                    assertionFailure("Unable to get game speed entity")
                    return
                }

                guard let gameSpeed = ecs.getComponent(ofType: FlappyBirdGameSpeed.self, for: gameSpeedEntity) else {
                    assertionFailure("Unable to get game speed component")
                    return
                }

                let speed = gameSpeed.speed

                let ticksPerSecond = 1.0 / 3 * speed
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

    private func setupWinLoseConditions() {
        blueprint = blueprint
            .forEachTick { timeContext, actionContext in
                let ecs = actionContext.ecs
                let characters = ecs.getEntities(with: [FlappyBirdCharacterTag.self])

                if characters.isEmpty {
                    let eventData = TerminateGameLoopEventData(timeInGame: timeContext.clockTimeInSecondsGame)
                    actionContext.events.emit(TerminateGameLoopEvent(eventData: eventData))
                }
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

        let characters = context.ecs.getEntities(with: [FlappyBirdCharacterTag.self])

        var movedCharacter: Entity? {
            for character in characters {
                let characterTag = context.ecs.getComponent(ofType: FlappyBirdCharacterTag.self, for: character)

                if characterTag?.characterId == tapEventData.characterId {
                    return character
                }
            }

            return nil
        }

        guard let movedCharacter else {
            assertionFailure("Unable to get character entity for id: \(tapEventData.characterId)")
            return
        }

        guard var characterPhysicsComponent
                = ecs.getComponent(ofType: PhysicsComponent.self, for: movedCharacter) else {
            assertionFailure("Unable to get PhysicsComponent for character id: \(tapEventData.characterId)")
            return
        }

        // Handle character 'flying'
        characterPhysicsComponent.impulse = FlappyBirdEntityCreator.impulseValue
        ecs.upsertComponent(characterPhysicsComponent, to: movedCharacter)
    }
}
