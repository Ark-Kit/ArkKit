import Foundation

protocol AbstractCanvasToViewPositionMapper {
    func transform(_ positionOnCanvas: CGPoint) -> CGPoint
}

struct CanvasToViewPositionMapper: AbstractCanvasToViewPositionMapper {
    var canvasFrame: CGRect
    var cameraComponent: CameraComponent?

    func transform(_ positionOnCanvas: CGPoint) -> CGPoint {
        guard let camera = cameraComponent else {
            return positionOnCanvas
        }

        let anchorPoint = camera.anchorPoint
        let viewPosition = camera.viewPosition
        // transform positionOnCanvas to position on view based on anchorPoint to viewPosition
        let positionOnView = positionOnCanvas
        return positionOnView
    }
}
