class ArkCameraSystem: UpdateSystem {
    var active: Bool

    init(active: Bool) {
        self.active = active
    }

    func update(deltaTime: Double, arkECS: ArkECS) {
        let entitiesWithCamera = arkECS.getEntities(with: [PlacedCamera.self])

        for entityWithCamera in entitiesWithCamera {
            guard let positionOfEntity = arkECS.getComponent(ofType: PositionComponent.self, for: entityWithCamera),
                  let cameraComp = arkECS.getComponent(ofType: PlacedCamera.self, for: entityWithCamera) else {
                continue
            }
            // track entity holding the camera based on the entity's position
            let updatedCameraComp = PlacedCamera(
                camera: PlacedComponent(
                    canvasPosition: positionOfEntity.position,
                    size: cameraComp.camera.size,
                    zoom: cameraComp.camera.zoom
                ),
                screenPosition: cameraComp.screenPosition
            )
            arkECS.upsertComponent(updatedCameraComp, to: entityWithCamera)
        }
    }
}
