protocol Renderable<Container> {
    associatedtype Container

    func render(into container: Container)
    func unmount()
}
