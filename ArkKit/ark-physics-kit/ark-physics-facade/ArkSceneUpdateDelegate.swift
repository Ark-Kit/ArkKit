import Foundation

protocol ArkSceneUpdateDelegate: AnyObject {
    func didContactBegin(between entityA: Entity, and entityB: Entity)
    func didContactEnd(between entityA: Entity, and entityB: Entity)
    func didFinishUpdate(_ deltaTime: TimeInterval)
}
