//
//  EmblemsView.swift
//  Chat
//
//  Created by Maria Myamlina on 23.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class EmblemsView: UIView {
    let animator = Animator()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(animator.gestureRecognizer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let count = self.gestureRecognizers?.count, count > 0 else {
            animator.touchesBegan(touches)
            return
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let count = self.gestureRecognizers?.count, count > 0 else {
            animator.touchesMoved(touches)
            return
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let count = self.gestureRecognizers?.count, count > 0 else {
            animator.touchesEnded(touches)
            return
        }
    }
}
