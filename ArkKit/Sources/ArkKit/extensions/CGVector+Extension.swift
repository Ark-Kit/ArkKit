import CoreGraphics

extension CGVector {
    public static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    public static func - (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }

    public static func * (lhs: CGFloat, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs * rhs.dx, dy: lhs * rhs.dy)
    }

    public static func / (lhs: CGVector, rhs: CGFloat) -> CGVector {
        CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
    }

    public static func += (lhs: inout CGVector, rhs: CGVector) {
        let sumVector = lhs + rhs
        lhs = sumVector
    }

    public func dot(with vector: CGVector) -> CGFloat {
        self.dx * vector.dx + self.dy * vector.dy
    }

    public func angle() -> CGFloat {
        atan2(dx, dy)
    }

    public func normalized() -> CGVector {
        self / self.magnitude()
    }

    public func magnitude() -> CGFloat {
        .squareRoot(dx * dx + dy * dy)()
    }

    public func reversed() -> CGVector {
        CGVector(dx: -self.dx, dy: -self.dy)
    }

    public var isZero: Bool {
        dx.isZero && dy.isZero
    }
}
