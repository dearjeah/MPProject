//
//  UIView+Ext.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation
import UIKit

public struct AssociatedKeys {
    static var actionState: UInt8 = 0
}

public typealias ActionTap = () -> Void


public extension UIView {
    /// add Multiple subviews using Variadic
    func addSubviews(_ view: UIView...) {
        view.forEach { self.addSubview($0) }
    }
    
    func removeAllSubView() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    func addBorder(thickness: CGFloat = 1.0,
                   withColor color: UIColor = .black,
                   radius: CGFloat = 8) {
        self.layer.borderWidth = thickness
        if #available(iOS 13.0, *) {
            self.layer.borderColor = color.resolvedColor(with: self.traitCollection).cgColor
        } else {
            self.layer.borderColor = color.cgColor
        }
        self.layer.cornerRadius = radius
    }
    
    var onClick: ActionTap? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.actionState) as? ActionTap else {
                return nil
            }
            return value
        }
        set {
            if newValue == nil {
                objc_removeAssociatedObjects(self)
            } else {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.actionState,
                    newValue,
                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
                
                self.tapWithAnimation()
            }
        }
    }
    
    func tapWithAnimation() {
        self.isUserInteractionEnabled = true
        self.gestureRecognizers?.removeAll()
        let longTap = UITapGestureRecognizer(target: self, action: #selector(viewLongTap(_:)))
        self.addGestureRecognizer(longTap)
    }
    
    @objc
    func viewLongTap(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state != .ended {
            animateView(alpha: 0.3)
            return
        } else if gesture.state == .ended {
            let touchLocation = gesture.location(in: self)
            if self.bounds.contains(touchLocation) {
                animateView(alpha: 1)
                onClick?()
                return
            }
        }
        animateView(alpha: 1)
    }
    
    fileprivate func animateView(alpha: CGFloat) {
        UIView.transition(
            with: self, duration: 0.3,
            options: .transitionCrossDissolve, animations: {
                self.subviews.forEach { subView in
                    subView.alpha = alpha
                }
            })
    }
}
