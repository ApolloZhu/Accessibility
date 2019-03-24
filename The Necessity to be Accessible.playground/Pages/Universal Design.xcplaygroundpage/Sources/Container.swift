import UIKit

public func makeContainer(for views: UIView...,
    ofSize size: CGSize = CGSize(width: 200, height: 100)) -> UIView {
    let view = UIView(frame: CGRect(origin: .zero, size: size))
    view.backgroundColor = .white
    views.forEach { view.addSubview($0) }
    return view
}

