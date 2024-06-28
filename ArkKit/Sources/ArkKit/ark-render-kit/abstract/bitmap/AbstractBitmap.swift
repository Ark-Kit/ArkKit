import Foundation

protocol AbstractBitmap {
    func clipToBounds() -> Self
    func scaleAspectFit() -> Self
    func scaleToFill() -> Self
    func scaleAspectFill() -> Self
}
