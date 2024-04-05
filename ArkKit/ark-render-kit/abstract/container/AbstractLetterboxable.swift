import Foundation

protocol AbstractLetterboxable {
    var letterboxWidthScaleFactor: CGFloat { get }
    func letterbox(into screenSize: CGSize) -> Self
}
