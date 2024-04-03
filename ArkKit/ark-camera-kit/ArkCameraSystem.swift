class ArkCameraSystem: UpdateSystem {
    var active: Bool

    init(active: Bool) {
        self.active = active
    }

    func update(deltaTime: Double, arkECS: ArkECS) {
        guard let entityWithCamera = arkECS.getEntities(with: [CameraComponent.self]).first else {
            return
        }
        guard let positionOfEntity = arkECS.getComponent(ofType: PositionComponent.self, for: entityWithCamera),
              let cameraComp = arkECS.getComponent(ofType: CameraComponent.self, for: entityWithCamera) else {
            return
        }
        let updatedCameraComp = CameraComponent(position: positionOfEntity.position,
                                                zoom: cameraComp.zoom)
        arkECS.upsertComponent(updatedCameraComp, to: entityWithCamera)
    }
}
