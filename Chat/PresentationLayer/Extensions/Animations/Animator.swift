//
//  Animator.swift
//  Chat
//
//  Created by Maria Myamlina on 22.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class Animator: NSObject {
    // MARK: - Emblems
    let screenSize = CGPoint(x: UIScreen.main.bounds.width / 2,
                             y: UIScreen.main.bounds.height / 2)
    
    lazy var gestureRecognizer: UILongPressGestureRecognizer = {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                             action: #selector(handleLongPress(_:)))
        gestureRecognizer.minimumPressDuration = 0.6
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()
    
    lazy var emblemCell: CAEmitterCell = {
        var emblemCell = CAEmitterCell()
        emblemCell.contents = UIImage(named: "Emblem")?.cgImage
        emblemCell.scale = 0.02
        emblemCell.scaleRange = 0.05
        emblemCell.emissionRange = .pi * 2
        emblemCell.lifetime = 3
        emblemCell.birthRate = 40
        emblemCell.velocity = 80
        emblemCell.velocityRange = -50
        emblemCell.spin = -0.5
        emblemCell.spinRange = 1.0
        emblemCell.alphaSpeed = 1
        emblemCell.alphaRange = 2
        return emblemCell
    }()

    let emblemLayer = CAEmitterLayer()
    
    func showEmblem(into view: UIView, in location: CGPoint) {
        emblemLayer.emitterPosition = location
        emblemLayer.beginTime = CACurrentMediaTime()
        emblemLayer.birthRate = 1.0
        emblemLayer.emitterCells = [emblemCell]
        view.layer.addSublayer(emblemLayer)
    }
    
    func touchesBegan(_ touches: Set<UITouch>) {
        let touch = touches.first
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600)) {
            self.showEmblem(into: touch?.view ?? UIView(),
                            in: touch?.location(in: touch?.view ?? UIView()) ?? self.screenSize)
        }
    }

    func touchesMoved(_ touches: Set<UITouch>) {
        let touch = touches.first
        emblemLayer.emitterPosition = touch?.location(in: touch?.view ?? UIView()) ?? screenSize
    }

    func touchesEnded(_ touches: Set<UITouch>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
            self.emblemLayer.birthRate = 0
        }
    }
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            showEmblem(into: sender.view ?? UIView(),
                       in: sender.location(in: sender.view))
        case .changed:
            emblemLayer.emitterPosition = sender.location(in: sender.view)
        case .ended:
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
                self.emblemLayer.birthRate = 0
            }
        default:
            break
        }
    }
    
    // MARK: - Button
    func startTrembling(for button: ButtonWithTouchSize, position startPosition: CGPoint) {
        button.layer.removeAnimation(forKey: "comeBack")
        
        let positionX = startPosition.x
        let positionY = startPosition.y
        let minAngle = NSNumber(value: 0)
        let maxAngle = Double.pi / 10

        let animationMoveHorizontally = CAKeyframeAnimation(keyPath: "position.x")
        animationMoveHorizontally.values = [positionX,
                                            positionX + 5,
                                            positionX,
                                            positionX - 5,
                                            positionX]
        animationMoveHorizontally.keyTimes = [0.0, 0.15, 0.3, 0.5, 1.0]

        let animationMoveVertically = CAKeyframeAnimation(keyPath: "position.y")
        animationMoveVertically.values = [positionY,
                                          positionY + 5,
                                          positionY,
                                          positionY - 5,
                                          positionY]
        animationMoveVertically.keyTimes = [0.0, 0.5, 0.7, 0.85, 1.0]

        let animationRotate = CAKeyframeAnimation(keyPath: "transform.rotation")
        animationRotate.values = [minAngle,
                                  NSNumber(value: maxAngle),
                                  minAngle,
                                  NSNumber(value: -maxAngle),
                                  minAngle]
        animationRotate.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        
        [animationMoveHorizontally, animationMoveVertically, animationRotate].forEach { $0.duration = 0.3 }
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.repeatCount = .infinity
        group.animations = [
            animationMoveHorizontally,
            animationRotate,
            animationMoveVertically
        ]

        button.layer.add(group, forKey: "moveAndRotate")
    }
    
    func stopTrembling(for button: ButtonWithTouchSize, position startPosition: CGPoint) {
        let animationMove = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        animationMove.fromValue = button.layer.presentation()?.position
        animationMove.toValue = startPosition
        animationMove.duration = 0.5
        
        button.layer.add(animationMove, forKey: "comeBack")
        button.layer.removeAnimation(forKey: "moveAndRotate")
    }
    
    // MARK: - Keyboard
    func animateKeyboard(animation: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut,
                       animations: animation, completion: completion)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension Animator: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return true
    }
}
