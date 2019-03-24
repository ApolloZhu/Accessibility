import UIKit

public enum UIAccessibility {
    public static var isReduceMotionEnabled: Bool = false
}

public func makeWelcomeView(
    ofSize size: CGSize = CGSize(width: 400, height: 400)) -> UIView {
    let view = WelcomeView(frame: CGRect(origin: .zero, size: size))
    WelcomeView.current = view
    return view
}

public func enableAnimation() {
    WelcomeView.current?.isAnimating = true
}

public func disableAnimation() {
    WelcomeView.current?.isAnimating = false
}

class WelcomeView: UIView {

    
    fileprivate static var current: WelcomeView?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        backgroundColor = #colorLiteral(red: 0.07058823529, green: 0.1019607843, blue: 0.1843137255, alpha: 1)
        
        let label = UILabel()
        label.text = "🤯"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.sizeToFit()
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    var isAnimating = true {
        didSet {
            emitterLayer.emitterCells?.forEach {
                $0.birthRate = isAnimating ? 1.2 : 0
            }
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        defer { super.draw(rect) }
        if isAnimating { return }
        for image in images {
            let template = image.withRenderingMode(.alwaysTemplate)
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            for color in colors {
                color.setFill()
                let x = CGFloat.random(in: 0...bounds.width)
                let y = CGFloat.random(in: 0...bounds.height)
                template.draw(in: CGRect(
                    x: x - imageWidth, y: y - imageHeight,
                    width: imageWidth, height: imageHeight
                ))
            }
        }
    }

}

let colors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)]
let images = (1...10).map { UIImage(named: "\($0).png")! }


class AnimatingView: UIView {
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    
    var emitterLayer: CAEmitterLayer {
        return layer as! CAEmitterLayer
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        emitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        emitterLayer.renderMode = .unordered
        emitterLayer.emitterCells = makeEmitterCells()
    }
    
    
    private func makeEmitterCells() -> [CAEmitterCell] {
        return images.flatMap { image -> [CAEmitterCell] in
            return colors.shuffled().map { color -> CAEmitterCell in
                let cell = CAEmitterCell()
                cell.color = color.cgColor
                cell.contents = image.cgImage
                cell.lifetime = 5
                cell.birthRate = 1.2
                cell.alphaSpeed = -0.3
                cell.velocity = 70
                cell.zAcceleration = 10
                cell.emissionRange = 2 * .pi
                cell.spin = 1
                cell.spinRange = 1
                return cell
            }
        }
    }
}
