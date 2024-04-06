import Foundation

class ArkCameraSystem: UpdateSystem {
    var active: Bool

    init(active: Bool = true) {
        self.active = active
    }

    func update(deltaTime: Double, arkECS: ArkECS) {
        let entitiesWithCamera = arkECS.getEntities(with: [CameraContainerComponent.self])

        for entityWithCamera in entitiesWithCamera {
            guard let positionOfEntity = arkECS.getComponent(ofType: PositionComponent.self, for: entityWithCamera),
                  let cameraComp = arkECS.getComponent(
                    ofType: CameraContainerComponent.self, for: entityWithCamera
                  ) else {
                continue
            }
            // track entity holding the camera based on the entity's position
            let updatedCameraPosition = translateToCameraPosition(
                positionOfEntity.position,
                screenSize: cameraComp.screenSize,
                cameraSize: cameraComp.size
            )

            let updatedCameraComp = CameraContainerComponent(
                camera: Camera(
                    canvasPosition: positionOfEntity.position,
                    zoom: cameraComp.camera.zoom
                ),
                screenPosition: cameraComp.screenPosition,
                screenSize: cameraComp.screenSize,
                size: cameraComp.size
            )
            arkECS.upsertComponent(updatedCameraComp, to: entityWithCamera)
        }
    }

    func translateToCameraPosition(_ position: CGPoint, screenSize: CGSize, cameraSize: CGSize) -> CGPoint {
//        let cameraFrame = CGRect(origin: position, size: cameraSize)
//        let screenFrame = CGRect(origin: .zero, size: screenSize)
//        let bestFitFrame = CGRect(x: max(cameraFrame.minX, screenFrame.minX),
//                                  y: max(cameraFrame.minY, screenFrame.minY),
//                                  width: cameraSize.width,
//                                  height: cameraSize.height)
//        return CGPoint(x: bestFitFrame.midX, y: bestFitFrame.midY)
        let minX = cameraSize.width / 2
        let maxX = screenSize.width - cameraSize.width / 2
        let minY = cameraSize.height / 2
        let maxY = screenSize.height - cameraSize.height / 2

        let clampedX = max(minX, min(position.x, maxX))
        let clampedY = max(minY, min(position.y, maxY))

        return CGPoint(x: clampedX, y: clampedY)
    }
}
