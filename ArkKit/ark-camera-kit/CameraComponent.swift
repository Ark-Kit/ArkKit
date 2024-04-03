import Foundation

/**
 * Defines the visible portion of the canvas based off the `anchorPoint`
 */
struct CameraComponent: Component {
    /// Defines the view position on camera from the concrete `view`
    /// The `viewPosition` should be fixed, fixing the camera at a particular
    /// point on the screen.
    let viewPosition: CGPoint

    /// Defines the anchor position within the `canvas` (game world).
    let anchorPoint: CGPoint

    /// Defines the size of the camera view relative to the `canvas` size.
    /// The size of the camera should be at most the size of the `canvas`.
    let size: CGSize

    let zoom: Double

    init(viewPosition: CGPoint, anchorPoint: CGPoint, size: CGSize, zoom: Double = 1.0) {
        self.viewPosition = viewPosition
        self.anchorPoint = anchorPoint
        self.zoom = zoom
        self.size = size
    }
}
