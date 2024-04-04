import Foundation

protocol ArkCameraContext {
    func transform(_ canvas: any Canvas) -> any Canvas
}

// struct ArkCameraManager: ArkCameraContext {
//    func transform(_ canvas: any Canvas) -> any Canvas {
//        // transform the canvas into a camera canvas by translating positions
//        // clip to bounds to the camera size so it does not show more than necessary
//    }
// }
