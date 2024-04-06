import Foundation

protocol AbstractView<View>: AnyObject {
    associatedtype View

    var abstractView: View { get }

    typealias ScreenResizeDelegate = (CGSize) -> Void
    func didMove(to parent: any AbstractParentView<View>)
    func onScreenResize(_ delegate: @escaping ScreenResizeDelegate)
}
