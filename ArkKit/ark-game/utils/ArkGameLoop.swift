import QuartzCore

// class ArkGameLoop: GameLoop {
//    var updatePhysicsSceneDelegate: (any ArkPhysicsSceneUpdateLoopDelegate)?
//
//    func update() {
//        // not use
//    }
//
//    typealias SetUpDisplayLinkDelegate = () -> CADisplayLink
//    var displayLink: CADisplayLink
//    init(_ displayLinkSetUpCallback: SetUpDisplayLinkDelegate) {
//        self.displayLink = displayLinkSetUpCallback()
//    }
//    func getDeltaTime() -> Double {
//        let target = displayLink.targetTimestamp
//        let previous = displayLink.timestamp
//        return target - previous
//    }
//    func setUp() {
//        self.displayLink.add(to: .main, forMode: .default)
//    }
//    func shutDown() {
//        self.displayLink.invalidate()
//    }
// }
