import UIKit

class ArkViewFactory {
    static func generateView(_ parentView: AbstractParentView) -> ArkView? {
        if parentView is UIViewController {
            return ArkUIKitView()
        }
        // TODO: add SwiftUI version
        return nil
    }
}
