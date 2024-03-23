import Foundation

protocol AbstractView: AnyObject {
    typealias ScreenResizeDelegate = (CGSize) -> Void
    func didMove(to parent: AbstractParentView)
    func onScreenResize(_ delegate: @escaping ScreenResizeDelegate)
}
