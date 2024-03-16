import UIKit

protocol ShapeRenderable: Renderable {
    associatedtype Color

    func fill(color: Color) -> Self
    func stroke(lineWidth: Double, color: Color) -> Self
}
