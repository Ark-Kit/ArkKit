import Foundation

protocol System: AnyObject {
    var active: Bool { get set }
    func run(using runner: SystemRunner)
}
