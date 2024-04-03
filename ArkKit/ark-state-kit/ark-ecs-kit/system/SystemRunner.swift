import Foundation

/**
 * Runs each different `System` using the Visitor / Double-dispatch pattern
 */
protocol SystemRunner {
    func run(_ system: StartUpSystem)
    func run(_ system: UpdateSystem)
    func run(_ system: CleanUpSystem)
}

struct ArkSystemRunner: SystemRunner {
    var deltaTime: TimeInterval?
    var arkECS: ArkECS?

    func run(_ system: any StartUpSystem) {
        system.startup()
    }

    func run(_ system: any UpdateSystem) {
        guard let dt = deltaTime, let ecs = arkECS else {
            return
        }
        system.update(deltaTime: dt, arkECS: ecs)
    }

    func run(_ system: any CleanUpSystem) {
        system.cleanup()
    }
}
