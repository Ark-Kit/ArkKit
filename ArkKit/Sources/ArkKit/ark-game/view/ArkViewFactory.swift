import UIKit

class ArkViewFactory {
    static func generateView<T>(_ parentView: any AbstractParentView<T>) -> (any ArkView<T>)? {
        guard let arkView = ArkUIKitView<UIView>() as? (any ArkView<T>) else {
            return nil
        }
        return arkView
    }
}
