import Foundation

class TankRaceEventHandler {
    let tankIdEntityMap: [Int: Entity]
    var collisionStrategyManager = TankRaceGameCollisionStrategyManager()
    let finishLineEntities: [Entity]

    init(tankIdEntityMap: [Int: Entity], finishLineEntities: [Entity]) {
        self.tankIdEntityMap = tankIdEntityMap
        self.finishLineEntities = finishLineEntities
    }

    func handleTankSteer(_ event: TankRaceSteeringEvent,
                         in context: TankRaceGameActionContext) {
        let ecs = context.ecs
        let tankSteerEventData = event.eventData
        guard let tankEntity = tankIdEntityMap[tankSteerEventData.tankId] else {
            return
        }
        guard var tankRotationComponent = ecs.getComponent(
                  ofType: RotationComponent.self,
                  for: tankEntity)
        else {
            return
        }
        tankRotationComponent.angleInRadians = tankSteerEventData.angleInRadians
        ecs.upsertComponent(tankRotationComponent, to: tankEntity)
    }

    func handleTankPedal(_ event: TankRacePedalEvent, in context: TankRaceGameActionContext) {
        let ecs = context.ecs
        let tankMoveEventData = event.eventData
        guard let tankEntity = tankIdEntityMap[tankMoveEventData.tankId] else {
            return
        }

        guard var tankPhysicsComponent = ecs.getComponent(
            ofType: PhysicsComponent.self,
            for: tankEntity),
            let tankRotationComponent = ecs.getComponent(
                ofType: RotationComponent.self,
                for: tankEntity)
        else {
            return
        }

        let magnitude = 1_000.0

        let velocityX = magnitude * cos((tankRotationComponent.angleInRadians ?? 0.0) - Double.pi / 2)
        let velocityY = magnitude * sin((tankRotationComponent.angleInRadians ?? 0.0) - Double.pi / 2)

        tankPhysicsComponent.isDynamic = true
        tankPhysicsComponent.velocity = CGVector(dx: velocityX, dy: velocityY)
        ecs.upsertComponent(tankPhysicsComponent, to: tankEntity)
        context.events.emit(TankRaceEndPedalEvent(eventData: tankMoveEventData))
    }

    func handleTankPedalEnd(_ event: TankRaceEndPedalEvent,
                            in context: TankRaceGameActionContext) {
        let ecs = context.ecs
        let tankMoveEventData = event.eventData
        guard let tankEntity = tankIdEntityMap[tankMoveEventData.tankId] else {
            return
        }

        guard var tankPhysicsComponent = ecs.getComponent(
            ofType: PhysicsComponent.self,
            for: tankEntity)
        else {
            return
        }

        tankPhysicsComponent.velocity = .zero
        ecs.upsertComponent(tankPhysicsComponent, to: tankEntity)
    }

    func handleContactBegan(_ event: ArkCollisionBeganEvent,
                            in context: TankRaceGameActionContext) {
        let eventData = event.eventData

        let entityA = eventData.entityA
        let entityB = eventData.entityB
        let bitMaskA = eventData.entityACategoryBitMask
        let bitMaskB = eventData.entityBCategoryBitMask

        collisionStrategyManager.handleCollisionBegan(between: entityA, and: entityB,
                                                      bitMaskA: bitMaskA, bitMaskB: bitMaskB,
                                                      in: context)

        let tankEntities = Set(tankIdEntityMap.compactMap { _, value in value })
        let finishLineSet = Set(finishLineEntities)
        if (tankEntities.contains(entityA) || tankEntities.contains(entityB)) &&
            (finishLineSet.contains(entityA) || finishLineSet.contains(entityB)) {
            // win condition reached
            // retrieve tank id
            guard let tankId = tankIdEntityMap.filter { _, entity in
                entity == entityA || entity == entityB
            }.map { tankId, _ in tankId }.first else {
                return
            }
            let tankWinEventData = TankWinEventData(name: "TankWon", tankId: tankId)
            let tankWinEvent = TankWinEvent(eventData: tankWinEventData)
            context.events.emit(tankWinEvent)
        }
    }

    func handleWin(_ event: TankWinEvent, view: AbstractDemoGameHostingPage) {
        let tankWinEventData = event.eventData
        let winner = tankWinEventData.tankId
        let tankWinView = TankWinCustomView()
        tankWinView.winner = String(winner)
        view.present(tankWinView, animated: true)
    }

    func handleTankShoot(_ event: TankShootEvent, in context: TankRaceGameActionContext) {
        let ecs = context.ecs
        let eventData = event.eventData
        guard let tankEntity = tankIdEntityMap[eventData.tankId],
              let tankPositionComponent = ecs.getComponent(ofType: PositionComponent.self, for: tankEntity),
              let tankRotationComponent = ecs.getComponent(ofType: RotationComponent.self, for: tankEntity),
              let tankPhysicsComponent = ecs.getComponent(ofType: PhysicsComponent.self, for: tankEntity) else {
            return
        }
        let tankLength = (tankPhysicsComponent.size?.height ?? 0.0) / 2 + 20

        let dx = cos((tankRotationComponent.angleInRadians ?? 0.0) - Double.pi / 2)
        let dy = sin((tankRotationComponent.angleInRadians ?? 0.0) - Double.pi / 2)
        let ballRadius = 15.0
        let ballVelocity = 600.0

        TankGameEntityCreator
            .createBall(with: TankBallCreationContext(
                position: CGPoint(x: tankPositionComponent.position.x + dx * (tankLength + ballRadius * 1.1),
                                  y: tankPositionComponent.position.y + dy * (tankLength + ballRadius * 1.1)),
                radius: ballRadius,
                velocity: CGVector(dx: ballVelocity * dx,
                                   dy: ballVelocity * dy),
                angle: tankRotationComponent.angleInRadians ?? 0,
                zPosition: 5),
                in: ecs)
    }

    func handleRockHpModify(_ event: TankHpModifyEvent, in context: TankRaceGameActionContext) {
        let ecs = context.ecs
        let eventData = event.eventData
        let tankEntity = eventData.tankEntity
        guard var tankHpComponent = ecs.getComponent(ofType: TankHpComponent.self, for: tankEntity),
              let hpBarComponent = ecs.getComponent(ofType: RectRenderableComponent.self, for: tankEntity) else {
            return
        }
        let hpChange = eventData.hpChange
        let newHp = tankHpComponent.hp + hpChange
        tankHpComponent.hp = newHp
        ecs.upsertComponent(tankHpComponent, to: tankEntity)
        let newHpBarComponent =
                    TankGameEntityCreator.createHpBarComponent(hp: newHp, zPosition: hpBarComponent.zPosition)
        ecs.upsertComponent(newHpBarComponent, to: tankEntity)

        if newHp <= 0 {
            let tankDestroyedEvent =
                    TankDestroyedEvent(eventData: TankDestroyedEventData(name: "Tank \(tankEntity) destroyed",
                                                                         tankEntity: tankEntity))
            context.events.emit(tankDestroyedEvent)
        }
    }

    func handleRockDestroyed(_ event: TankDestroyedEvent, in context: TankRaceGameActionContext) {
        let ecs = context.ecs
        let eventData = event.eventData
        let tankEntity = eventData.tankEntity
        guard let tankHpComponent = context.ecs.getComponent(ofType: TankHpComponent.self, for: tankEntity),
              tankHpComponent.hp <= 0 else {
            return
        }
        context.ecs.upsertComponent(ToRemoveComponent(), to: tankEntity)
        if let positionComponent = context.ecs.getComponent(ofType: PositionComponent.self, for: tankEntity) {
            ImpactExplosionAnimation(perFrameDuration: 0.1,
                                     width: 256.0,
                                     height: 256.0)
            .create(in: ecs, at: positionComponent.position)
        }
    }
}
