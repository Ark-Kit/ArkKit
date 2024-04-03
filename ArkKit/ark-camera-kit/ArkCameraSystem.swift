class ArkCameraSystem: UpdateSystem {
    var active: Bool

    init(active: Bool) {
        self.active = active
    }

    func update(deltaTime: Double, arkECS: ArkECS) {
        let entitiesWithCamera = arkECS.getEntities(with: [CameraComponent.self])

        for entityWithCamera in entitiesWithCamera {
            guard let positionOfEntity = arkECS.getComponent(ofType: PositionComponent.self, for: entityWithCamera),
                  let cameraComp = arkECS.getComponent(ofType: CameraComponent.self, for: entityWithCamera) else {
                continue
            }
            // track entity holding the camera based on the entity's position
            let updatedCameraComp = CameraComponent(anchorPoint: positionOfEntity.position,
                                                    size: cameraComp.size,
                                                    zoom: cameraComp.zoom)
            arkECS.upsertComponent(updatedCameraComp, to: entityWithCamera)
        }
    }
}
