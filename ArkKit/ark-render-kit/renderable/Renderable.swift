protocol Renderable {
    associatedtype Container

    func render(into container: Container)
    func unmount()
}
