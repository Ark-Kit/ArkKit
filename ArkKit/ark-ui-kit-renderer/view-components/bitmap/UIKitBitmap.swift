import UIKit

protocol UIKitBitmap: BitmapRenderable, UIKitRenderable {}

extension UIKitBitmap {
    func applyModifiers(modifierInfo: BitmapImageCanvasComponent) -> Self {
        self
            .if(modifierInfo.isClipToBounds, transform: { view in view.clipToBounds() })
            .if(modifierInfo.isScaleAspectFill, transform: { view in view.scaleAspectFill() })
            .if(modifierInfo.isScaleAspectFit, transform: { view in view.scaleAspectFit() })
            .if(modifierInfo.isScaleToFill, transform: { view in view.scaleToFill() })
    }

    func clipToBounds() -> Self {
        self.clipsToBounds = true
        return self
    }
    func scaleAspectFit() -> Self {
        self.contentMode = .scaleAspectFit
        return self
    }
    func scaleToFill() -> Self {
        self.contentMode = .scaleToFill
        return self
    }
    func scaleAspectFill() -> Self {
        self.contentMode = .scaleAspectFill
        return self
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
