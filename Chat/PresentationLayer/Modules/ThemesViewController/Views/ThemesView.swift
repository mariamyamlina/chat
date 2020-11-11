//
//  ThemesView.swift
//  Chat
//
//  Created by Maria Myamlina on 07.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ThemesView: UIView {
    var currentTheme = Settings.currentTheme.themeSettings
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        let attr: [NSAttributedString.Key: Any] = [.font: UIFont(name: "SFProText-Semibold", size: 17) as Any]
        let attrString = NSMutableAttributedString(string: "Settings", attributes: attr)
        title.attributedText = attrString
        return title
    }()
    
    lazy var classicButton: ThemeButton = {
        let classicButton = ThemeButton(titleLabel: "Classic",
                                        backgroundColor: Colors.classicAndDayButtonColor,
                                        inputColor: Colors.inputGray,
                                        outputColor: Colors.outputGreen)
        
        addSubview(classicButton)
        classicButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            classicButton.topAnchor.constraint(equalTo: topAnchor, constant: 180),
            classicButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            classicButton.widthAnchor.constraint(equalToConstant: 300),
            classicButton.heightAnchor.constraint(equalToConstant: 101),
            classicButton.bottomAnchor.constraint(equalTo: dayButton.topAnchor, constant: -40)
        ])
        return classicButton
    }()
    
    lazy var dayButton: ThemeButton = {
        let dayButton = ThemeButton(titleLabel: "Day",
                                    backgroundColor: Colors.classicAndDayButtonColor,
                                    inputColor: Colors.inputLightGray,
                                    outputColor: Colors.outputBlue)
        
        addSubview(dayButton)
        dayButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dayButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayButton.widthAnchor.constraint(equalToConstant: 300),
            dayButton.heightAnchor.constraint(equalToConstant: 101),
            dayButton.bottomAnchor.constraint(equalTo: nightButton.topAnchor, constant: -40)
        ])
        return dayButton
    }()
    
    lazy var nightButton: ThemeButton = {
        let nightButton = ThemeButton(titleLabel: "Night",
                                      backgroundColor: Colors.nightButtonColor,
                                      inputColor: Colors.inputDarkGray,
                                      outputColor: Colors.outputDarkGray)
        
        addSubview(nightButton)
        nightButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nightButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nightButton.widthAnchor.constraint(equalToConstant: 300),
            nightButton.heightAnchor.constraint(equalToConstant: 101),
            nightButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
        ])
        return nightButton
    }()
    
    func applyTheme() {
        currentTheme = Settings.currentTheme.themeSettings
        backgroundColor = currentTheme.settingsBackgroundColor
        if #available(iOS 13.0, *) {
        } else {
            titleLabel.textColor = currentTheme.textColor
        }
        chooseSelectedButton()
    }
    
    func chooseSelectedButton() {
        switch currentTheme {
        case is ClassicTheme:
            classicButton.isSelected = true
            dayButton.isSelected = false
            nightButton.isSelected = false

            setupButtonView(for: classicButton, selected: true)
        case is DayTheme:
            classicButton.isSelected = false
            dayButton.isSelected = true
            nightButton.isSelected = false

            setupButtonView(for: dayButton, selected: true)
        case is NightTheme:
            classicButton.isSelected = false
            dayButton.isSelected = false
            nightButton.isSelected = true
            
            setupButtonView(for: nightButton, selected: true)
        default:
            break
        }
    }
    
    func setupButtonView(for button: ThemeButton, selected state: Bool) {
        if state {
            button.backgroundView.layer.borderWidth = 3
            button.backgroundView.layer.borderColor = Colors.outputBlue.cgColor
        } else {
            button.backgroundView.layer.borderWidth = 0
            button.backgroundView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func pickButtonTapped(_ sender: ThemeButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            setupButtonView(for: sender, selected: true)
            switch sender {
            case classicButton:
                if dayButton.isSelected {
                    pickButtonTapped(dayButton)
                } else if nightButton.isSelected {
                    pickButtonTapped(nightButton)
                }
            case dayButton:
                if classicButton.isSelected {
                    pickButtonTapped(classicButton)
                } else if nightButton.isSelected {
                    pickButtonTapped(nightButton)
                }
            case nightButton:
                if dayButton.isSelected {
                    pickButtonTapped(dayButton)
                } else if classicButton.isSelected {
                    pickButtonTapped(classicButton)
                }
            default:
                break
            }
        } else {
            switch sender {
            case classicButton:
                if dayButton.isSelected || nightButton.isSelected {
                    setupButtonView(for: sender, selected: false)
                } else {
                    sender.isSelected = !sender.isSelected
                }
            case dayButton:
                if classicButton.isSelected || nightButton.isSelected {
                    setupButtonView(for: sender, selected: false)
                } else {
                    sender.isSelected = !sender.isSelected
                }
            case nightButton:
                if dayButton.isSelected || classicButton.isSelected {
                    setupButtonView(for: sender, selected: false)
                } else {
                    sender.isSelected = !sender.isSelected
                }
            default:
                break
            }
        }
    }
}
