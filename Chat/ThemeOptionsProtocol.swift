//
//  ThemeOptionsProtocol.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

protocol ThemeOptionsProtocol {
    var inputBubbleColor: UIColor { get }
    var outputBubbleColor: UIColor { get }
    
    var textColor: UIColor { get }
    var outputTextColor: UIColor { get }
    var messageLabelColor: UIColor { get }
    
    var barColor: UIColor { get }
    var alertColor: UIColor { get }
    var saveButtonColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var settingsBackgroundColor: UIColor { get }
    
    var inputTimeColor: UIColor { get }
    var outputTimeColor: UIColor { get }
    
    var textFieldBackgroundColor: UIColor { get }
    var textFieldTextColor: UIColor { get }
    var searchBarTextColor: UIColor { get }
    
    var barStyle: UIBarStyle { get }
    var keyboardAppearance: UIKeyboardAppearance { get }
    
    var tableViewSeparatorColor: UIColor { get }
    var tableViewHeaderTextColor: UIColor { get }
    var tableViewHeaderColor: UIColor { get }
}
