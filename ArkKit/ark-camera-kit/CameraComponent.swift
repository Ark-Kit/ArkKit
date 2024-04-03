import Foundation

struct CameraComponent: Component {
    let position: CGPoint
    let zoom: Double

    init(position: CGPoint, zoom: Double = 1.0) {
        self.position = position
        self.zoom = zoom
    }
}
