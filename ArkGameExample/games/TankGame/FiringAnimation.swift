import Foundation

struct FiringAnimation {
    let animation: ArkAnimation<TankGameFiringAnimationKeyframes>

    var width: Double
    var height: Double

    init(perFrameDuration: Double, width: Double = 64.0, height: Double = 64.0) {
        animation = ArkAnimation()
            .keyframe(.Flash_A_01, duration: perFrameDuration)
            .keyframe(.Flash_A_02, duration: perFrameDuration)
            .keyframe(.Flash_A_03, duration: perFrameDuration)
            .keyframe(.Flash_A_04, duration: perFrameDuration)
            .keyframe(.Flash_A_05, duration: perFrameDuration)
        self.width = width
        self.height = height
    }

    private func makeBitmapComponent(imageResourcePath: TankGameFiringAnimationKeyframes, position: CGPoint) ->
    BitmapImageRenderableComponent {
        BitmapImageRenderableComponent(
            arkImageResourcePath: imageResourcePath,
            width: width,
            height: height)
        .center(position)
        .scaleAspectFill()
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
            .onKeyframeUpdate { instance in
                let keyframe = instance.currentFrame
                let imageResourcePath = keyframe.value

                var bitmapComponent = ecs.getComponent(ofType: BitmapImageRenderableComponent.self,
                                                       for: entity) ?? makeBitmapComponent(
                                                        imageResourcePath: imageResourcePath,
                                                        position: position)

                bitmapComponent.imageResourcePath = imageResourcePath.rawValue

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

        let bitmapComponent = makeBitmapComponent(imageResourcePath: .Flash_A_01, position: position)
        ecs.upsertComponent(bitmapComponent, to: entity)
    }
}
