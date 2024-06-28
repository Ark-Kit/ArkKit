import Foundation

public struct PlacedCameraComponent: Component {
    public let camera: Camera

    /// Screen position is the center of the camera placed on to the screen coordinate
    public let screenPosition: CGPoint

    /// Defines the size of the camera view relative to the `screen` size.
    /// The size of the camera should be at most the size of the `screen`.
    public let size: CGSize

    public init(camera: Camera,
                screenPosition: CGPoint,
                size: CGSize) {
        self.camera = camera
        self.screenPosition = screenPosition
        self.size = size
    }
}

/**
 * Defines the visible portion of the canvas based off the `canvasPosition`.
 * The camera takes a slice of renderable components at the canvas layer based off the size.
 */
public struct Camera: Codable {
    /// Defines the anchor position within the `canvas` (game world).
    public let canvasPosition: CGPoint

    public let zoom: CameraZoom

    public init(canvasPosition: CGPoint,
                zoom: Double = 1.0) {
        self.canvasPosition = canvasPosition
        self.zoom = CameraZoom(widthZoom: zoom, heightZoom: zoom)
    }

    public init(canvasPosition: CGPoint,
                zoomWidth: Double = 1.0,
                zoomHeight: Double = 1.0) {
        self.canvasPosition = canvasPosition
        self.zoom = CameraZoom(widthZoom: zoomWidth,
                               heightZoom: zoomHeight)
    }
}

public struct CameraZoom: Codable {
    public let widthZoom: Double
    public let heightZoom: Double

    public init(widthZoom: Double,
                heightZoom: Double) {
        self.widthZoom = widthZoom
        self.heightZoom = heightZoom
    }
}
