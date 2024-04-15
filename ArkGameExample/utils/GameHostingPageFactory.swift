class GameHostingPageFactory {
    // Factory method
    static func generateGameViewController(from game: DemoGames) -> AbstractDemoGameHostingPage {
        switch game {
        case .TankGame:
            let blueprint: ArkBlueprint<TankGameExternalResources> = TankGameManager().blueprint
            let vc: ArkDemoGameHostingPage<TankGameExternalResources> = ArkDemoGameHostingPage()
            vc.arkBlueprint = blueprint
            return vc
        case .SnakeChomp:
            let blueprint: ArkBlueprint<SnakeGameExternalResources> = SnakeGame().blueprint
            let vc: ArkDemoGameHostingPage<SnakeGameExternalResources> = ArkDemoGameHostingPage()
            vc.arkBlueprint = blueprint
            return vc
        case .TankRaceGame:
            let blueprint: ArkBlueprint<TankRaceGameExternalResources> = TankRaceGame().blueprint
            let vc: ArkDemoGameHostingPage<TankRaceGameExternalResources> = ArkDemoGameHostingPage()
            vc.arkBlueprint = blueprint
            return vc
        case .FlappyBird:
            let blueprint: ArkBlueprint<FlappyBirdExternalResources> = FlappyBird().blueprint
            let vc: ArkDemoGameHostingPage<FlappyBirdExternalResources> = ArkDemoGameHostingPage()
            vc.arkBlueprint = blueprint
            return vc
        }
    }
}
