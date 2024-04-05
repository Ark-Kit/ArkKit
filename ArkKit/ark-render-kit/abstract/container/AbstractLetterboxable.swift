import Foundation

protocol AbstractLetterboxable {
    var letterboxScaleFactor: CGFloat { get }
    func letterbox(into screenSize: CGSize) -> Self
}
