//
//  ThemesViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 02.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ThemesViewController: LogViewController {
    var changeThemeHandler: ((_ theme: Theme) -> Void)?
    weak var delegate: ThemesPickerDelegate?
    private var themeManager: ThemeManager?
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        let attr: [NSAttributedString.Key: Any] = [.font: UIFont(name: "SFProText-Semibold", size: 17) as Any]
        let attrString = NSMutableAttributedString(string: "Settings", attributes: attr)
        title.attributedText = attrString
        return title
    }()
    
    fileprivate lazy var classicButton: ThemeButton = {
        let classicButton = ThemeButton(title: "Classic",
                                 backgroundColor: Colors.classicAndDayButtonColor,
                                 inputColor: Colors.inputGray,
                                 outputColor: Colors.outputGreen)
        
        view.addSubview(classicButton)
        classicButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            classicButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            classicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            classicButton.widthAnchor.constraint(equalToConstant: 300),
            classicButton.heightAnchor.constraint(equalToConstant: 101),
            classicButton.bottomAnchor.constraint(equalTo: dayButton.topAnchor, constant: -40)
        ])
        return classicButton
    }()
    
    fileprivate lazy var dayButton: ThemeButton = {
        let dayButton = ThemeButton(title: "Day",
                                 backgroundColor: Colors.classicAndDayButtonColor,
                                 inputColor: Colors.inputLightGray,
                                 outputColor: Colors.outputBlue)
        
        view.addSubview(dayButton)
        dayButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dayButton.widthAnchor.constraint(equalToConstant: 300),
            dayButton.heightAnchor.constraint(equalToConstant: 101),
            dayButton.bottomAnchor.constraint(equalTo: nightButton.topAnchor, constant: -40)
        ])
        return dayButton
    }()
    
    fileprivate lazy var nightButton: ThemeButton = {
        let nightButton = ThemeButton(title: "Night",
                                 backgroundColor: Colors.nightButtonColor,
                                 inputColor: Colors.inputDarkGray,
                                 outputColor: Colors.outputDarkGray)
        
        view.addSubview(nightButton)
        nightButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nightButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nightButton.widthAnchor.constraint(equalToConstant: 300),
            nightButton.heightAnchor.constraint(equalToConstant: 101),
            nightButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10)
        ])
        return nightButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createHandler()
    }
    
    // MARK: - Theme Picker
    
    private func createHandler() {
        classicButton.pickHandler = { [weak self] in
            self?.pickButtonTapped(self?.classicButton ?? ThemeButton())

            self?.changeThemeHandler?(.classic)
            self?.delegate?.changeTheme(for: .classic)
        }
        
        dayButton.pickHandler = { [weak self] in
            self?.pickButtonTapped(self?.dayButton ?? ThemeButton())
            
            self?.changeThemeHandler?(.day)
            self?.delegate?.changeTheme(for: .day)
        }
        
        nightButton.pickHandler = { [weak self] in
            self?.pickButtonTapped(self?.nightButton ?? ThemeButton())
            
            self?.changeThemeHandler?(.night)
            self?.delegate?.changeTheme(for: .night)
        }
    }
    
    private func pickButtonTapped(_ sender: ThemeButton) {
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
    
    func applyTheme() {
        let currentTheme = Theme.current.themeOptions
        view.backgroundColor = currentTheme.settingsBackgroundColor
        if #available(iOS 13.0, *) {
        } else {
            titleLabel.textColor = currentTheme.textColor
            navigationController?.navigationBar.barStyle = currentTheme.barStyle
            navigationController?.navigationBar.barTintColor = currentTheme.barColor
        }
    }
    
    // MARK: - View
    
    private func setupView() {
        configureNavigationBar()
        
        themeManager = ThemeManager(themesVC: self)
        applyTheme()
        let currentTheme = Theme.current.themeOptions
        
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
    
    private func setupButtonView(for button: ThemeButton, selected state: Bool) {
        if state {
            button.backgroundView.layer.borderWidth = 3
            button.backgroundView.layer.borderColor = Colors.outputBlue.cgColor
        } else {
            button.backgroundView.layer.borderWidth = 0
            button.backgroundView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    // MARK: - Navigation
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = titleLabel
    }
}
