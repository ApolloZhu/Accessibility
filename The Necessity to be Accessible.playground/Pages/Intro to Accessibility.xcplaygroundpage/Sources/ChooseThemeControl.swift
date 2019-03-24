import UIKit

public func makeThemeChoosingImageButton() -> UIImageView {
    return ChooseThemeControl(image: UIImage(named: "paint")!.withRenderingMode(.alwaysTemplate))
}

class ChooseThemeControl: UIImageView {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if isUserInteractionEnabled { return }
        isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleTheme))
        tapGestureRecognizer.numberOfTapsRequired = 1
        addGestureRecognizer(tapGestureRecognizer)
        tintColor = .black
    }
    
    @objc private func toggleTheme() {
        if tintColor == .white {
            tintColor = .black
            backgroundColor = .white
            accessibilityValue = "Light Theme"
        } else {
            tintColor = .white
            backgroundColor = .black
            accessibilityValue = "Dark Theme"
        }
    }
}
