import SpriteKit

protocol AbstractArkSKPhysicsBody: AbstractArkPhysicsBody {
    var node: SKNode { get }
}
