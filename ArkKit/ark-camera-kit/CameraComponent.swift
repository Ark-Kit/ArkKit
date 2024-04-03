import Foundation


/**
 * Defines the visible portion of the canvas based off the `anchorPoint`
 */
struct CameraComponent: Component {
    /// Defines the anchor position within the `canvas` (game world).
    let anchorPoint: CGPoint

    /// Defines the size of the camera view relative to the `canvas` size.
    let size: CGSize

    let zoom: Double
    

    init(anchorPoint: CGPoint, size: CGSize, zoom: Double = 1.0) {
        self.anchorPoint = anchorPoint
        self.zoom = zoom
        self.size = size
    }
}
