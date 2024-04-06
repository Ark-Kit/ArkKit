import Foundation

class ArkCameraSystem: UpdateSystem {
    var active: Bool

    init(active: Bool = true) {
        self.active = active
    }

    func update(deltaTime: Double, arkECS: ArkECS) {
        let entitiesWithCamera = arkECS.getEntities(with: [PlacedCameraComponent.self])

        for entityWithCamera in entitiesWithCamera {
            guard let positionOfEntity = arkECS.getComponent(ofType: PositionComponent.self, for: entityWithCamera),
                  let cameraComp = arkECS.getComponent(
                    ofType: PlacedCameraComponent.self, for: entityWithCamera
                  ) else {
                continue
            }
            // track entity holding the camera based on the entity's position
//            let updatedCameraPosition = translateToCameraPosition(
//                positionOfEntity.position,
//                canvasSize: cameraComp.canvasSize,
//                size: cameraComp.size
//            )

            let updatedCameraComp = PlacedCameraComponent(
                camera: Camera(
                    canvasPosition: positionOfEntity.position,
                    canvasSize: cameraComp.camera.canvasSize,
                    zoom: cameraComp.camera.zoom
                ),
                screenPosition: cameraComp.screenPosition,
                size: cameraComp.size
            )
            arkECS.upsertComponent(updatedCameraComp, to: entityWithCamera)
        }
    }

    func translateToCameraPosition(_ position: CGPoint, canvasSize: CGSize, size: CGSize) -> CGPoint {
        let minX = size.width / 2
        let maxX = canvasSize.width - size.width / 2
        let minY = size.height / 2
        let maxY = canvasSize.height - size.height / 2

        let clampedX = max(minX, min(position.x, maxX))
        let clampedY = max(minY, min(position.y, maxY))

        return CGPoint(x: clampedX, y: clampedY)
    }
}
