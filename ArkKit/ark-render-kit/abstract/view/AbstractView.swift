import Foundation

protocol AbstractView<View>: AnyObject {
    associatedtype View

    typealias ScreenResizeDelegate = (CGSize) -> Void
    func didMove(to parent: any AbstractParentView<View>)
    func onScreenResize(_ delegate: @escaping ScreenResizeDelegate)
}
