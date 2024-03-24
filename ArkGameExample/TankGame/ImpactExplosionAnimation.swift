import Foundation

struct ImpactExplosionAnimation {
    let animation: ArkAnimation<String>

    let width = 128.0
    let height = 128.0

    init(perFrameDuration: Double) {
        animation = ArkAnimation()
            .keyframe("Sprite_Effects_Explosion_001", duration: perFrameDuration)
            .keyframe("Sprite_Effects_Explosion_002", duration: perFrameDuration)
            .keyframe("Sprite_Effects_Explosion_003", duration: perFrameDuration)
            .keyframe("Sprite_Effects_Explosion_004", duration: perFrameDuration)
            .keyframe("Sprite_Effects_Explosion_005", duration: perFrameDuration)
            .keyframe("Sprite_Effects_Explosion_006", duration: perFrameDuration)
            .keyframe("Sprite_Effects_Explosion_007", duration: perFrameDuration)
            .keyframe("Sprite_Effects_Explosion_008", duration: perFrameDuration)
    }

    private func makeBitmapComponent(imageResourcePath: String) -> BitmapImageRenderableComponent {
        BitmapImageRenderableComponent(
            imageResourcePath: imageResourcePath,
            width: width,
            height: height)
        .zPosition(100)
        .shouldRerender { old, new in
            old.imageResourcePath != new.imageResourcePath
        }
    }

    func create(in ecs: ArkECSContext, at position: CGPoint) {
        let entity = ecs.createEntity()
        ecs.upsertComponent(PositionComponent(position: position), to: entity)

        let animationInstance = animation
            .toInstance()
            .onUpdate { instance in
                let keyframe = instance.currentFrame
                let imageResourcePath = keyframe.value

                var bitmapComponent = ecs.getComponent(ofType: BitmapImageRenderableComponent.self,
                                                       for: entity) ?? makeBitmapComponent(
                                                        imageResourcePath: imageResourcePath)

                bitmapComponent.imageResourcePath = imageResourcePath

                ecs.upsertComponent(bitmapComponent, to: entity)
            }
            .onComplete { instance in
                instance.markForDestroyal()
                ecs.removeEntity(entity)
            }
        let animationsComponent = ArkAnimationsComponent(animations: [
            animationInstance
        ])
        ecs.upsertComponent(animationsComponent, to: entity)

        let bitmapComponent = makeBitmapComponent(imageResourcePath: "Sprite_Effects_Explosion_001")
        ecs.upsertComponent(bitmapComponent, to: entity)
    }
}
