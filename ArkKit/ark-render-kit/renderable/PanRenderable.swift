protocol PanRenderable: Renderable {
    func onPanStart()
    func onPanEnd()
    func onPanChange()
}
