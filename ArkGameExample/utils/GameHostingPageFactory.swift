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
                print(roomName)
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
            let ark = Ark(rootView: vc, blueprint: blueprint)
            vc.ark = ark
            return vc
        case .TankRaceGame:
            let vc: ArkDemoGameHostingPage<TankRaceGameExternalResources> = ArkDemoGameHostingPage()
            let blueprint: ArkBlueprint<TankRaceGameExternalResources> = TankRaceGame(rootView: vc).blueprint
//            vc.arkBlueprint = blueprint
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
                let gameVC = self.generateGameViewController(from: game, as: .participant, in: roomName)
                parentDelegate.pushViewController(gameVC, animated: true)
            }

            popover.onStart = { roomName in
                let gameVC = generateGameViewController(from: game, as: .host, in: roomName)
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
