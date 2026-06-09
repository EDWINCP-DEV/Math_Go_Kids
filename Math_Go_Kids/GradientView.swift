//
//  GradientView.swift
//  Math_Go_Kids
//
//  Created by Edwin Oswaldo Corona Perez on 08/06/26.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var topColor: UIColor = .clear {
        didSet { updateGradient() }
    }
    
    @IBInspectable var bottomColor: UIColor = .clear {
        didSet { updateGradient() }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    private func updateGradient() {
        guard let gradientLayer = layer as? CAGradientLayer else { return }
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
}
