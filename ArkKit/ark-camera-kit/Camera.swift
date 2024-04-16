import Foundation

struct PlacedCameraComponent: Component {
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
struct Camera: Codable {
    /// Defines the anchor position within the `canvas` (game world).
    let canvasPosition: CGPoint

    let zoom: CameraZoom

    init(canvasPosition: CGPoint,
         zoom: Double = 1.0) {
        self.canvasPosition = canvasPosition
        self.zoom = CameraZoom(widthZoom: zoom, heightZoom: zoom)
    }

    init(canvasPosition: CGPoint,
         zoomWidth: Double = 1.0,
         zoomHeight: Double = 1.0) {
        self.canvasPosition = canvasPosition
        self.zoom = CameraZoom(widthZoom: zoomWidth,
                               heightZoom: zoomHeight)
    }
}

struct CameraZoom: Codable {
    let widthZoom: Double
    let heightZoom: Double
}
