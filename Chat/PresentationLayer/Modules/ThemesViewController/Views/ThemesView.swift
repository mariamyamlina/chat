//
//  ThemesView.swift
//  Chat
//
//  Created by Maria Myamlina on 07.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ThemesView: UIView {
    // MARK: - UI
    var theme: Theme
    
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
        
        createConstraints(for: classicButton)
        classicButton.topAnchor.constraint(equalTo: topAnchor, constant: 140).isActive = true
        classicButton.bottomAnchor.constraint(equalTo: dayButton.topAnchor, constant: -40).isActive = true
        return classicButton
    }()
    
    lazy var dayButton: ThemeButton = {
        let dayButton = ThemeButton(titleLabel: "Day",
                                    backgroundColor: Colors.classicAndDayButtonColor,
                                    inputColor: Colors.inputLightGray,
                                    outputColor: Colors.outputBlue)
        
        createConstraints(for: dayButton)
        dayButton.bottomAnchor.constraint(equalTo: nightButton.topAnchor, constant: -40).isActive = true
        return dayButton
    }()
    
    lazy var nightButton: ThemeButton = {
        let nightButton = ThemeButton(titleLabel: "Night",
                                      backgroundColor: Colors.nightButtonColor,
                                      inputColor: Colors.inputDarkGray,
                                      outputColor: Colors.outputDarkGray)
        
        createConstraints(for: nightButton)
        return nightButton
    }()
    
    private func createConstraints(for button: ThemeButton) {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 300).isActive = true
        button.heightAnchor.constraint(equalToConstant: 101).isActive = true
    }
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(theme: Theme) {
        self.theme = theme
        super.init(frame: CGRect.zero)
    }
    
    // MARK: - Setup View
    func applyTheme(theme: Theme) {
        self.theme = theme
        backgroundColor = theme.settings.settingsBackgroundColor
        if #available(iOS 13.0, *) {
        } else {
            titleLabel.textColor = theme.settings.textColor
        }
        chooseSelectedButton()
    }
    
    func chooseSelectedButton() {
        switch theme.settings {
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
