import Foundation

class TankGameManager {

    private(set) var blueprint: ArkBlueprint

    init(frameWidth: Double, frameHeight: Double) {
        // 820, 1180
        self.blueprint = ArkBlueprint(frameWidth: frameWidth, frameHeight: frameHeight)
        setUp()
    }

    func setUp() {
        setUpEntities()
        setUpSystems()
        setUpRules()

            // Define game with blueprint here.
        self.blueprint = self.blueprint
            .setup({ ecsContext, eventContext in

                let tankEntity1 = TankGameEntityCreator.createTank(at: CGPoint(x: 0, y: 0),
                                                                   tankIndex: 1, in: ecsContext)

                TankGameEntityCreator.createJoyStick(center: CGPoint(x: 150, y: 150), tankEntity: tankEntity1,
                                                     in: ecsContext)
                TankGameEntityCreator.createJoyStick(center: CGPoint(x: 670, y: 1_030), tankEntity: tankEntity1,
                                                     in: ecsContext)

                ecsContext.createEntity(with: [
                    ButtonCanvasComponent(width: 50, height: 50, center: CGPoint(x: 500, y: 500),
                                          areValuesEqual: { _, _ in true })
                    .addOnTapDelegate(delegate: {
                        print("emiting event")
                        var demoEvent: any ArkEvent = DemoArkEvent()
                        eventContext.emit(&demoEvent)
                        print("done emit event")
                    })
                ])
            })
            .rule(on: DemoArkEvent.self, then: Forever { _, _, _ in
                print("running rule")
            })
    }

    func setUpEntities() {

    }

    func setUpSystems() {

    }

    func setUpRules() {

    }

}
