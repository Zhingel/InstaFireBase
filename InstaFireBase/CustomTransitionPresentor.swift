//
//  CustomTransitionPresentor.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 04.11.2021.
//

import Foundation
import UIKit

class CustomTransitionPresentor: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView =  transitionContext.view(forKey: .to) else {return}
        containerView.addSubview(toView)
        let startingFrame = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
        toView.frame = startingFrame
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
        } completion: { _ in
            transitionContext.completeTransition(true)
        }

        
    }
    
    
}