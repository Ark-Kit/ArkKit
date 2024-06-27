import Foundation

public protocol AbstractRootView<View>: AbstractParentView {
    var size: CGSize { get }
}
