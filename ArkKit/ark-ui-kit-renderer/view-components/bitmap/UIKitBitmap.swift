import UIKit

protocol UIKitBitmap: BitmapRenderable, UIKitRenderable {
    // TODO: add methods if needed
    // e.g. constraints
    func clipToBounds()
    func scaleAspectFit()
    func scaleToFill()
    func scaleAspectFill()
}

extension UIKitBitmap {
    func clipToBounds() {
        uiView.clipsToBounds = true
    }
    func scaleAspectFit() {
        uiView.contentMode = .scaleAspectFit
    }
    func scaleToFill() {
        uiView.contentMode = .scaleToFill
    }
    func scaleAspectFill() {
        uiView.contentMode = .scaleAspectFill
    }
}

class UIKitImageBitmap: UIKitBitmap {
    private(set) var uiView: UIView
    
    init(imageResourcePath: String, center: CGPoint, width: Double, height: Double) {
        let imageResource = #imageLiteral(resourceName: imageResourcePath)
        self.uiView = UIImageView(image: imageResource)
        self.uiView.frame = CGRect(x: center.x, y: center.y, width: width, height: height)
    }
}
