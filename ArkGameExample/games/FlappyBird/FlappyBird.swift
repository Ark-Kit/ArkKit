import Foundation

class FlappyBird {
    private(set) var blueprint: ArkBlueprint<FlappyBirdExternalResources>
    private var characterIdToEntityMap = [Int: Entity]()

    init() {
        self.blueprint = ArkBlueprint(frameWidth: 800, frameHeight: 1_180)
        setup()
    }

    private func setup() {
        setupPlayer()
        setupRules()

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

        characterPhysicsComponent.isDynamic = true
        characterPhysicsComponent.impulse = CGVector(dx: 0, dy: -100)
        characterPhysicsComponent.linearDamping = 10
        ecs.upsertComponent(characterPhysicsComponent, to: characterEntity)
    }

    private func setupPlayer() {
        blueprint = blueprint
            .setup { context in
                let ecs = context.ecs
                let display = context.display

                let canvasWidth = display.canvasSize.width
                let canvasHeight = display.canvasSize.height
                let canvasCenter = CGPoint(x: canvasWidth / 2, y: canvasHeight / 2)

                let screenWidth = display.screenSize.width
                let screenHeight = display.screenSize.height

                let radius: Double = 20
                let character = ecs.createEntity(with: [
                    CircleRenderableComponent(radius: radius)
                        .fill(color: .red)
                        .zPosition(1)
                        .layer(.canvas),
                    PositionComponent(position: canvasCenter),
                    RotationComponent(),
                    // isDynamic false at the start till the player makes the first tap
                    PhysicsComponent(shape: .circle, radius: radius,
                                     isDynamic: false, affectedByGravity: true,
                                     categoryBitMask: FlappyBirdPhysicsCategory.character,
                                     collisionBitMask: FlappyBirdPhysicsCategory.wall,
                                     contactTestBitMask: FlappyBirdPhysicsCategory.none)

                ])
                self.characterIdToEntityMap[1] = character

                let button = ButtonRenderableComponent(width: 70, height: 70)
                    .shouldRerender { old, new in old.center != new.center }
                    .center(CGPoint(x: screenWidth * 3 / 12, y: canvasHeight * 10 / 11))
                    .zPosition(999)
                    .onTap {
                        let flappyBirdTapEventData = FlappyBirdTapEventData(name: "FlappyBirdTapEvent", characterId: 1)
                        let flappyBirdTapEvent = FlappyBirdTapEvent(eventData: flappyBirdTapEventData)
                        context.events.emit(flappyBirdTapEvent)
                    }
                    .label("Fly!", color: .white)
                    .background(color: .gray)
                    .padding(top: 5, bottom: 5, left: 5, right: 5)
                    .layer(.screen)

                ecs.createEntity(with: [button])
            }
    }
}
