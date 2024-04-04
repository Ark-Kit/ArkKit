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
            let updatedCameraComp = CameraContainerComponent(
                camera: Camera(
                    canvasPosition: positionOfEntity.position,
                    size: cameraComp.camera.size,
                    zoom: cameraComp.camera.zoom
                ),
                screenPosition: cameraComp.screenPosition
            )
//            arkECS.upsertComponent(updatedCameraComp, to: entityWithCamera)
        }
    }
}
