/*
See LICENSE folder for this sample’s licensing information.

Abstract:
View that displays a bounding box and optional bezier path.
*/

import UIKit

class BoundingBoxView: UIView, AnimatedTransitioning {
    
    var boxborderColor = R.color.mainRed()! {
        didSet {
            setNeedsDisplay()
        }
    }
    var borderCornerSize = CGFloat(10)
    var boxborderWidth = CGFloat(3)
    var borderCornerRadius = CGFloat(4)
    var backgroundOpacity = CGFloat(1)
    var visionRect = CGRect.null
    var visionPath: CGPath? {
        didSet {
            updatePathLayer()
        }
    }
    
    private let pathLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }

    private func initialSetup() {
        isOpaque = false
        backgroundColor = .clear
        contentMode = .redraw
        pathLayer.strokeColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1).cgColor
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.lineWidth = 2
        layer.addSublayer(pathLayer)
    }
    
    override func draw(_ rect: CGRect) {
        boxborderColor.setStroke()
        boxborderColor.withAlphaComponent(backgroundOpacity).setFill()
        let backgroundPath = UIBezierPath(roundedRect: bounds, cornerRadius: borderCornerRadius)
        backgroundPath.fill()
        let borderPath: UIBezierPath
        let borderRect = bounds.insetBy(dx: boxborderWidth / 2, dy: boxborderWidth / 2)
        if borderCornerSize == 0 {
            borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: borderCornerRadius)
        } else {
            var cornerSizeH = borderCornerSize
            if cornerSizeH > borderRect.width / 2 - borderCornerRadius {
                cornerSizeH = max(borderRect.width / 2 - borderCornerRadius, 0)
            }
            var cornerSizeV = borderCornerSize
            if cornerSizeV > borderRect.height / 2 - borderCornerRadius {
                cornerSizeV = max(borderRect.height / 2 - borderCornerRadius, 0)
            }
            let cornerSize = CGSize(width: cornerSizeH, height: cornerSizeV)
            borderPath = UIBezierPath(cornersOfRect: borderRect, cornerSize: cornerSize, cornerRadius: borderCornerRadius)
        }
        borderPath.lineWidth = boxborderWidth
        borderPath.stroke()
    }
    
    func containedInside(_ otherBox: BoundingBoxView) -> Bool {
        return otherBox.frame.contains(frame)
    }
    
    private func updatePathLayer() {
        guard let visionPath = self.visionPath else {
            pathLayer.path = nil
            return
        }
        let path = UIBezierPath(cgPath: visionPath)
        path.apply(CGAffineTransform.verticalFlip)
        path.apply(CGAffineTransform(scaleX: bounds.width, y: bounds.height))
        pathLayer.path = path.cgPath
    }
}

extension CGAffineTransform {
    static var verticalFlip = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -1)
}

extension UIBezierPath {
    convenience init(cornersOfRect borderRect: CGRect, cornerSize: CGSize, cornerRadius: CGFloat) {
        self.init()
        let cornerSizeH = cornerSize.width
        let cornerSizeV = cornerSize.height
        // top-left
        move(to: CGPoint(x: borderRect.minX, y: borderRect.minY + cornerSizeV + cornerRadius))
        addLine(to: CGPoint(x: borderRect.minX, y: borderRect.minY + cornerRadius))
        addArc(withCenter: CGPoint(x: borderRect.minX + cornerRadius, y: borderRect.minY + cornerRadius),
               radius: cornerRadius,
               startAngle: CGFloat.pi,
               endAngle: -CGFloat.pi / 2,
               clockwise: true)
        addLine(to: CGPoint(x: borderRect.minX + cornerSizeH + cornerRadius, y: borderRect.minY))
        // top-right
        move(to: CGPoint(x: borderRect.maxX - cornerSizeH - cornerRadius, y: borderRect.minY))
        addLine(to: CGPoint(x: borderRect.maxX - cornerRadius, y: borderRect.minY))
        addArc(withCenter: CGPoint(x: borderRect.maxX - cornerRadius, y: borderRect.minY + cornerRadius),
               radius: cornerRadius,
               startAngle: -CGFloat.pi / 2,
               endAngle: 0,
               clockwise: true)
        addLine(to: CGPoint(x: borderRect.maxX, y: borderRect.minY + cornerSizeV + cornerRadius))
        // bottom-right
        move(to: CGPoint(x: borderRect.maxX, y: borderRect.maxY - cornerSizeV - cornerRadius))
        addLine(to: CGPoint(x: borderRect.maxX, y: borderRect.maxY - cornerRadius))
        addArc(withCenter: CGPoint(x: borderRect.maxX - cornerRadius, y: borderRect.maxY - cornerRadius),
               radius: cornerRadius,
               startAngle: 0,
               endAngle: CGFloat.pi / 2,
               clockwise: true)
        addLine(to: CGPoint(x: borderRect.maxX - cornerSizeH - cornerRadius, y: borderRect.maxY))
        // bottom-left
        move(to: CGPoint(x: borderRect.minX + cornerSizeH + cornerRadius, y: borderRect.maxY))
        addLine(to: CGPoint(x: borderRect.minX + cornerRadius, y: borderRect.maxY))
        addArc(withCenter: CGPoint(x: borderRect.minX + cornerRadius,
                                   y: borderRect.maxY - cornerRadius),
               radius: cornerRadius,
               startAngle: CGFloat.pi / 2,
               endAngle: CGFloat.pi,
               clockwise: true)
        addLine(to: CGPoint(x: borderRect.minX, y: borderRect.maxY - cornerSizeV - cornerRadius))
    }
}

