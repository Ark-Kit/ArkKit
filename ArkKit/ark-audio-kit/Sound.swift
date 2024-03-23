protocol Sound: Hashable {
    var filename: String { get }
    var fileExtension: String { get }
    var numberOfLoops: Int { get }
}

extension Sound {
    func toString() -> String {
        "\(filename).\(fileExtension)"
    }
}

struct AnySound: Sound {
    let filename: String
    let fileExtension: String
    let numberOfLoops: Int

    init<S: Sound>(_ sound: S) {
        filename = sound.filename
        fileExtension = sound.fileExtension
        numberOfLoops = sound.numberOfLoops
    }
}
