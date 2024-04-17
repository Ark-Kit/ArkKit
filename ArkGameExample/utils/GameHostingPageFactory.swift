import UIKit

class GameHostingPageFactory {
    // Factory method
    static func generateGameViewController(from game: DemoGames, as role: ArkPeerRole? = nil,
                                           in roomName: String? = nil) -> AbstractDemoGameHostingPage {
        switch game {
        case .TankGame:
            let blueprint: ArkBlueprint<TankGameExternalResources> = TankGameManager()
                .blueprint
            let vc: ArkDemoGameHostingPage<TankGameExternalResources> = ArkDemoGameHostingPage()

            // inject ark and blueprint dependencies here
            if role == nil {
                vc.ark = Ark(rootView: vc, blueprint: blueprint)
            } else {
                guard let role = role,
                      let roomName = roomName else {
                    return vc
                }
                let updatedBlueprint = blueprint
                    .supportNetworkMultiPlayer(
                        roomName: "TankGame\(roomName)", numberOfPlayers: 2
                    )
                    .setRole(role)
                vc.ark = Ark(rootView: vc, blueprint: updatedBlueprint)
            }
            return vc
        case .SnakeChomp:
            let blueprint: ArkBlueprint<SnakeGameExternalResources> = SnakeGame().blueprint
            let vc: ArkDemoGameHostingPage<SnakeGameExternalResources> = ArkDemoGameHostingPage()
            if role == nil {
                vc.ark = Ark(rootView: vc, blueprint: blueprint)
            } else {
                guard let role = role,
                      let roomName = roomName else {
                    return vc
                }
                let updatedBlueprint = blueprint
                    .supportNetworkMultiPlayer(
                        roomName: "SnakeGame\(roomName)", numberOfPlayers: 2
                    )
                    .setRole(role)
                vc.ark = Ark(rootView: vc, blueprint: updatedBlueprint)
            }
            return vc
        case .TankRaceGame:
            let vc: ArkDemoGameHostingPage<TankRaceGameExternalResources> = ArkDemoGameHostingPage()
            let blueprint: ArkBlueprint<TankRaceGameExternalResources> = TankRaceGame(rootView: vc).blueprint
            let ark = Ark(rootView: vc, blueprint: blueprint)
            vc.ark = ark
            return vc
        case .FlappyBird:
            let vc: ArkDemoGameHostingPage<FlappyBirdExternalResources> = ArkDemoGameHostingPage()
            let blueprint: ArkBlueprint<FlappyBirdExternalResources> = FlappyBird(rootView: vc).blueprint

            let ark = Ark(rootView: vc, blueprint: blueprint)
            vc.ark = ark
            return vc
        }
    }

    static func loadGame(from game: DemoGames, with parentDelegate: RootViewControllerDelegate,
                         sourceView: UIView, sourceRect: CGRect) {
        if shouldPresentMultiplayerOptions(for: game) {
            let popover = ArkDemoMultiplayerPopover()
            popover.onJoin = { roomName in
                if roomName == nil {
                    loadGameLocally(game, with: parentDelegate)
                }
                let gameVC = self.generateGameViewController(from: game, as: .participant, in: roomName)
                parentDelegate.pushViewController(gameVC, animated: true)
            }

            popover.onStart = { roomName in
                if roomName == nil {
                    loadGameLocally(game, with: parentDelegate)
                    return
                }
                let gameVC = generateGameViewController(from: game, as: .host, in: roomName)
                parentDelegate.pushViewController(gameVC, animated: true)
            }

            parentDelegate.presentPopover(popover, sourceView: sourceView, sourceRect: sourceRect, animated: true)
        } else {
            loadGameLocally(game, with: parentDelegate)
        }
    }

    private static func loadGameLocally(_ game: DemoGames,
                                        with parentDelegate: RootViewControllerDelegate) {
        let gameVC = generateGameViewController(from: game)
        parentDelegate.pushViewController(gameVC, animated: true)
    }

    private static func shouldPresentMultiplayerOptions(for game: DemoGames) -> Bool {
        switch game {
        case .TankGame, .SnakeChomp:
            return true
        case .TankRaceGame, .FlappyBird:
            return false
        }
    }
}
