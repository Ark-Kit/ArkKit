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
        self.clipsToBounds = true
    }
    func scaleAspectFit() {
        self.contentMode = .scaleAspectFit
    }
    func scaleToFill() {
        self.contentMode = .scaleToFill
    }
    func scaleAspectFill() {
        self.contentMode = .scaleAspectFill
    }
}

class UIKitImageBitmap: UIView, UIKitBitmap {
    init(imageResourcePath: String, center: CGPoint, width: Double, height: Double) {
        let frame = CGRect(x: center.x, y: center.y, width: width, height: height)
        super.init(frame: frame)
        let imageResource = #imageLiteral(resourceName: imageResourcePath)
        let imageView = UIImageView(image: imageResource)
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
