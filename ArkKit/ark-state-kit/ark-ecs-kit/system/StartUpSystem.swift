protocol StartUpSystem: System {
    func startup()
}

extension StartUpSystem {
    func run(using runner: SystemRunner) {
        runner.run(self)
    }
}
