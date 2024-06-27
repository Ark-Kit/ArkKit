import Foundation

protocol ArkNetworkSubscriberDelegate: AnyObject {
    func onListen(_ data: Data)
}
