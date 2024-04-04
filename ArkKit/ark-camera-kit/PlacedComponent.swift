import Foundation

struct PlacedCamera: Component {
    let camera: PlacedComponent
    let screenPosition: CGPoint
}

/**
 * Defines the visible portion of the canvas based off the `anchorPoint`
 */
struct PlacedComponent {
    /// Defines the anchor position within the `canvas` (game world).
    let canvasPosition: CGPoint

    /// Defines the size of the camera view relative to the `canvas` size.
    /// The size of the camera should be at most the size of the `canvas`.
    let size: CGSize

    let zoom: Double

    init(canvasPosition: CGPoint, size: CGSize, zoom: Double = 1.0) {
        self.canvasPosition = canvasPosition
        self.zoom = zoom
        self.size = size
    }
}
