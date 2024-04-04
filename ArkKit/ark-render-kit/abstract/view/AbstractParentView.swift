protocol AbstractParentView<View>: AnyObject {
    associatedtype View
    func pushView(_ view: any AbstractView<View>, animated: Bool)
}
