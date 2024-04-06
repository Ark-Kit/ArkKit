protocol AbstractParentView<View>: AnyObject {
    associatedtype View
    var abstractView: View { get }
    func pushView(_ view: any AbstractView<View>, animated: Bool)
}
