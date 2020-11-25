//
//  TextField + TextView.swift
//  Chat
//
//  Created by Maria Myamlina on 23.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class TextField: UITextField {
    let animator = Animator()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animator.touchesBegan(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        animator.touchesMoved(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animator.touchesEnded(touches)
    }
}

class TextView: UITextView {
    let animator = Animator()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animator.touchesBegan(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        animator.touchesMoved(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animator.touchesEnded(touches)
    }
}
