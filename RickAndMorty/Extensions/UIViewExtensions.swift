//
//  UIViewExtensions.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 19/09/2023.
//

import Foundation
import UIKit

extension UIView {
    func addPulseAnimation(delegate: CAAnimationDelegate? = nil, toValue: CGFloat = 1.12, repeatCount: Float = 1) {
        let pulse1 = CASpringAnimation(keyPath: "transform.scale")
        pulse1.duration = 0.3
        pulse1.fromValue = 1.0
        pulse1.toValue = toValue
        pulse1.autoreverses = true
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 0.5
        pulse1.damping = 0.3

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.5
        animationGroup.repeatCount = repeatCount
        animationGroup.animations = [pulse1]
        animationGroup.delegate = delegate

        self.layer.add(animationGroup, forKey: "pulse")
    }

    func animateView(isHidden: Bool, animated: Bool, duration: Double = 0.25, completion: ((Bool) -> Swift.Void)? = nil) {
        if self.isHidden != isHidden {
            if animated {
                UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
                    self.isHidden = isHidden
                }, completion: completion)
            } else {
                self.isHidden = isHidden
            }
        } else {
            completion?(true)
        }
    }
}
