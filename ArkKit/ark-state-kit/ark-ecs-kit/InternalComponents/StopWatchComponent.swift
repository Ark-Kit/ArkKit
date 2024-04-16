import Foundation

struct StopWatchComponent: SendableComponent {
    var currentTime: TimeInterval
    var name: String

    init(name: String) {
        self.currentTime = 0
        self.name = name
    }
}
