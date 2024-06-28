import Foundation

protocol ArkPhysicsContactUpdateDelegate: AnyObject {
    func didContactBegin(between entityA: Entity, and entityB: Entity)
    func didContactEnd(between entityA: Entity, and entityB: Entity)
}
