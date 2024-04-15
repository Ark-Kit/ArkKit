import Foundation

struct ImpactExplosionAnimation {
    let animation: ArkAnimation<TankGameExplosionAnimationKeyframes>

    var width = 128.0
    var height = 128.0

    init(perFrameDuration: Double, width: Double = 128.0, height: Double = 128.0) {
        animation = ArkAnimation()
            .keyframe(.Sprite_Effects_Explosion_001, duration: perFrameDuration)
            .keyframe(.Sprite_Effects_Explosion_002, duration: perFrameDuration)
            .keyframe(.Sprite_Effects_Explosion_003, duration: perFrameDuration)
            .keyframe(.Sprite_Effects_Explosion_004, duration: perFrameDuration)
            .keyframe(.Sprite_Effects_Explosion_005, duration: perFrameDuration)
            .keyframe(.Sprite_Effects_Explosion_006, duration: perFrameDuration)
            .keyframe(.Sprite_Effects_Explosion_007, duration: perFrameDuration)
            .keyframe(.Sprite_Effects_Explosion_008, duration: perFrameDuration)
        self.width = width
        self.height = height
    }

    private func makeBitmapComponent(imageResourcePath: TankGameExplosionAnimationKeyframes) ->
    BitmapImageRenderableComponent {
        BitmapImageRenderableComponent(
            imageResourcePath: imageResourcePath,
            width: width,
            height: height)
        .scaleAspectFill()
        .zPosition(100)
        .shouldRerender { old, new in
            old.imageResourcePath.rawValue != new.imageResourcePath.rawValue
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
                if instance.shouldDestroy {
                    ecs.removeEntity(entity)
                }
            }
        
        var animationsComponent = ArkAnimationsComponent()
        animationsComponent.addAnimation(animationInstance)
        ecs.upsertComponent(animationsComponent, to: entity)

        let bitmapComponent = makeBitmapComponent(imageResourcePath: .Sprite_Effects_Explosion_001)
        ecs.upsertComponent(bitmapComponent, to: entity)
    }
}
