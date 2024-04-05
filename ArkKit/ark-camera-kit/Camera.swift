import Foundation

struct CameraContainerComponent: Component {
    let camera: Camera

    /// Screen position is the center of the camera placed on to the screen coordinate
    let screenPosition: CGPoint

    /// Defines the size of the camera view relative to the `screen` size.
    /// The size of the camera should be at most the size of the `screen`.
    let size: CGSize
}

/**
 * Defines the visible portion of the canvas based off the `canvasPosition`.
 * The camera takes a slice of renderable components at the canvas layer based off the size.
 */
struct Camera {
    /// Defines the anchor position within the `canvas` (game world).
    let canvasPosition: CGPoint

    let zoom: Double

    init(canvasPosition: CGPoint, zoom: Double = 1.0) {
        self.canvasPosition = canvasPosition
        self.zoom = zoom
    }
}