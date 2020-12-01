//
//  Transition.swift
//  Chat
//
//  Created by Maria Myamlina on 22.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class Transition: NSObject {
    // MARK: - Dependencies
    let startIndicator: Bool
    let startFrame: CGRect
    let duration = 0.6
    
    // MARK: - Init / deinit
    init(startIndicator: Bool, startFrame: CGRect) {
        self.startIndicator = startIndicator
        self.startFrame = startFrame
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension Transition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from) else { return }
        var snapshotVC = fromVC
        
        var indicatorOne: CGFloat = 1
        var indicatorTwo: CGFloat = 0
        if startIndicator {
            indicatorOne = 0
            indicatorTwo = 1
            snapshotVC = toVC
        }
        
        guard let snapshot = snapshotVC.view.snapshotView(afterScreenUpdates: true) else { return }
        if startIndicator {
            snapshot.frame = self.startFrame
        }

        fromVC.view.isHidden = !startIndicator
        toVC.view.isHidden = startIndicator
        fromVC.view.alpha = indicatorTwo
        toVC.view.alpha = 0
        snapshot.alpha = indicatorOne
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)

        UIView.animate(withDuration: duration, delay: 0,
                       usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0,
                       options: [.curveEaseIn], animations: {
            if self.startIndicator {
                snapshot.frame = (transitionContext.finalFrame(for: toVC))
            } else {
                snapshot.frame = self.startFrame
            }
            fromVC.view.alpha = indicatorOne
            toVC.view.alpha = 1
            snapshot.alpha = indicatorTwo
        }, completion: { _ in
            if self.startIndicator {
                fromVC.view.isHidden = self.startIndicator
                toVC.view.isHidden = !self.startIndicator
                snapshot.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        })
    }
}
