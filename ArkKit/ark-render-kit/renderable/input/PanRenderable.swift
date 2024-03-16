typealias PanDelegate = (_ angle: Double, _ magnitude: Double) -> Void

protocol PanRenderable: Renderable {
    var onPanStartDelegate: PanDelegate? { get set }
    var onPanChangeDelegate: PanDelegate? { get set }
    var onPanEndDelegate: PanDelegate? { get set }

}

extension PanRenderable {
    mutating func addPanStartDelegate(delegate: @escaping PanDelegate) -> Self {
        self.onPanStartDelegate = delegate
        return self
    }
    mutating func addPanChangeDelegate(delegate: @escaping PanDelegate) -> Self {
        self.onPanChangeDelegate = delegate
        return self
    }
    mutating func addPanEndDelegate(delegate: @escaping PanDelegate) -> Self {
        self.onPanEndDelegate = delegate
        return self
    }
}
