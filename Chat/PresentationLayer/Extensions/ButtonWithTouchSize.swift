//
//  ButtonWithTouchSize.swift
//  Chat
//
//  Created by Maria Myamlina on 23.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ButtonWithTouchSize: UIButton {
    private var touchPath: UIBezierPath {
        return UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return touchPath.contains(point)
    }
}
