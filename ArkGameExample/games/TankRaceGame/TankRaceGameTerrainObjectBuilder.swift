class TankRaceGameTerrainObjectBuilder: TankGameTerrainObjectBuilder {
    override func buildObjects(from specifications: [TankPropSpecification]) {
        for spec in specifications {
            for strategy in strategies where strategy.canHandleType(spec.type) {
                let entity = strategy.createObject(type: spec.type,
                                                   location: spec.location,
                                                   size: spec.size,
                                                   zPos: spec.zPos,
                                                   in: ecsContext)
                ecsContext.upsertComponent(TankRaceGameEntityCreator.createHpBarComponent(hp: 50, zPosition: 5),
                                           to: entity)
                ecsContext.upsertComponent(TankHpComponent(hp: 50, maxHp: 50), to: entity)
                break
            }
        }
    }
}
