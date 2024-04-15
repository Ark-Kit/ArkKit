import UIKit

class GameHostingPageFactory {
    // Factory method
    static func generateGameViewController(from game: DemoGames, as role: ArkPeerRole? = nil) -> AbstractDemoGameHostingPage {
        switch game {
        case .TankGame:
            let blueprint: ArkBlueprint<TankGameExternalResources> = TankGameManager().blueprint
            let vc: ArkDemoGameHostingPage<TankGameExternalResources> = ArkDemoGameHostingPage()

            // inject ark and blueprint dependencies here
            if role == nil {
                vc.ark = Ark(rootView: vc, blueprint: blueprint)
            } else {
                guard let role = role else {
                    return vc
                }
                var updatedBlueprint = blueprint.setRole(role)
                vc.ark = Ark(rootView: vc, blueprint: updatedBlueprint)
            }
            return vc
        case .SnakeChomp:
            let blueprint: ArkBlueprint<SnakeGameExternalResources> = SnakeGame().blueprint
            let vc: ArkDemoGameHostingPage<SnakeGameExternalResources> = ArkDemoGameHostingPage()
            let ark = Ark(rootView: vc, blueprint: blueprint)
            vc.ark = ark
            return vc
        case .TankRaceGame:
            let blueprint: ArkBlueprint<TankRaceGameExternalResources> = TankRaceGame().blueprint
            let vc: ArkDemoGameHostingPage<TankRaceGameExternalResources> = ArkDemoGameHostingPage()
            let ark = Ark(rootView: vc, blueprint: blueprint)
            vc.ark = ark
            return vc
        }
    }

    static func loadGame(from game: DemoGames, with parentDelegate: RootViewControllerDelegate,
                         sourceView: UIView, sourceRect: CGRect) {
        if shouldPresentMultiplayerOptions(for: game) {
            let popover = ArkDemoMultiplayerPopover()
            popover.onJoin = {
                let gameVC = self.generateGameViewController(from: game, as: .participant)
                parentDelegate.pushViewController(gameVC, animated: true)
            }

            popover.onStart = {
                let gameVC = generateGameViewController(from: game, as: .host)
                parentDelegate.pushViewController(gameVC, animated: true)
            }

            parentDelegate.presentPopover(popover, sourceView: sourceView, sourceRect: sourceRect, animated: true)
        } else {
            let gameVC = generateGameViewController(from: game)
            parentDelegate.pushViewController(gameVC, animated: true)
        }
    }

    private static func shouldPresentMultiplayerOptions(for game: DemoGames) -> Bool {
        switch game {
        case .TankGame:
            return true
        case .SnakeChomp, .TankRaceGame:
            return false
        }
    }
}
