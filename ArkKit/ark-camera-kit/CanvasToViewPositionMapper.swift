import Foundation

protocol AbstractCanvasToViewPositionMapper {
    func transform(_ positionOnCanvas: CGPoint) -> CGPoint
}

struct CanvasToViewPositionMapper: AbstractCanvasToViewPositionMapper {
    var canvasFrame: CGRect
    var cameraComponent: PlacedCamera?

    func transform(_ positionOnCanvas: CGPoint) -> CGPoint {
        guard let cameraComp = cameraComponent else {
            return positionOnCanvas
        }

        let anchorPoint = cameraComp.camera.canvasPosition
        let viewPosition = cameraComp.screenPosition
        // transform positionOnCanvas to position on view based on anchorPoint to viewPosition
        let positionOnView = positionOnCanvas
        return positionOnView
    }
}
