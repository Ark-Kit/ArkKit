typealias TapDelegate = () -> Void

protocol TapRenderable: Renderable {
    var onTapDelegate: TapDelegate? { get set }
}

extension TapRenderable {
    mutating func addOnTapDelegate(delegate: @escaping TapDelegate) -> Self {
        self.onTapDelegate = delegate
        return self
    }
}
