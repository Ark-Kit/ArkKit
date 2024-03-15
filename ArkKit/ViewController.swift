import UIKit

class ViewController: UIViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let midX = view.frame.midX
        let midY = view.frame.midY
        // let circle = ArkUiShape().drawCircle(midX, midY, radius: 25)
        // self.view.addSubview(circle)
//        let circle = CircleUi(radius: 25, center: CGPoint(x: midX, y: midY))
//        circle.render(into: self.view)
//        let rect = RectUi(width: 50, height: 50, center: CGPoint(x: midX, y: midY))
//            .fill(color: .blue)
//            .stroke(lineWidth: 5.0, color: .red)
//        rect.render(into: self.view)
        let polygon = UIKitPolygon(points: [CGPoint(x: 0, y: 0),
                                            CGPoint(x: 100, y: 200),
                                            CGPoint(x: 200, y: 200)],
                                   frame: CGRect(x: midX - 100, y: midY - 100, width: 200, height: 200))
            .fill(color: .brown)
            .stroke(lineWidth: 5.0, color: .black)
        polygon.render(into: self.view)
        self.view.backgroundColor = .white
    }
}
