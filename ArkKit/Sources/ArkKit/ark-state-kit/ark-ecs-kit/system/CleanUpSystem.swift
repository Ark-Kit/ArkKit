protocol CleanUpSystem: System {
    func cleanup()
}

extension CleanUpSystem {
    func run(using runner: SystemRunner) {
        runner.run(self)
    }
}
