import Foundation

protocol AbstractRootView<View>: AbstractParentView {
    var size: CGSize { get }
}
