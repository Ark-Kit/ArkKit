import Foundation

protocol UpdateSystem: System {
    func update(deltaTime: TimeInterval, arkECS: ArkECS)
}

extension UpdateSystem {
    func run(using runner: SystemRunner) {
        runner.run(self)
    }
}
