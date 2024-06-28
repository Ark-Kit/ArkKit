public protocol Sound: Hashable {
    var filename: String { get }
    var fileExtension: String { get }
    var numberOfLoops: Int { get }
}

extension Sound {
    public func toString() -> String {
        "\(filename).\(fileExtension)"
    }
}

public struct AnySound: Sound {
    public let filename: String
    public let fileExtension: String
    public let numberOfLoops: Int

    public init<S: Sound>(_ sound: S) {
        filename = sound.filename
        fileExtension = sound.fileExtension
        numberOfLoops = sound.numberOfLoops
    }
}
