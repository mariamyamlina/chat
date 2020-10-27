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
    var delegate: ThemesPickerDelegate?
    private var themeManager: ThemeManager?
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        let attr: [NSAttributedString.Key: Any] = [.font: UIFont(name: "SFProText-Semibold", size: 17) as Any]
        let attrString = NSMutableAttributedString(string: "Settings", attributes: attr)
        title.attributedText = attrString
        return title
    }()
    
    @IBOutlet weak var classicButton: ThemeButton!
    @IBOutlet weak var dayButton: ThemeButton!
    @IBOutlet weak var nightButton: ThemeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        configureNavigationBar()
        createHandler()
        
        /*
         Retain cycle при работе с этом экраном может возникнуть, например, если self в замыкании pickHandler захватывается по сильной ссылке. В таком случае ThemesViewController содержит сильную ссылку на ThemeButton, а ThemeButton - сильную ссылку на self, то есть на ThemesViewController
         Неверный вариант использования замыкания-обработчика (приведет к retain cycle):
            myButton.pickHandler = {
                self....
            }
         Верный вариант с применением capture list (захватываем self по слабой ссылке):
            myButton.pickHandler = { [weak self] in
                self?....
            }
         */

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
    
    fileprivate func applyTheme() {
        let currentTheme = Theme.current.themeOptions
        view.backgroundColor = currentTheme.settingsBackgroundColor
        if #available(iOS 13.0, *) {
        } else {
            titleLabel.textColor = currentTheme.inputAndCommonTextColor
        }
    }
    
    
    // MARK: - View
    
    private func setupViews() {
        ThemeManager.themesViewController = self
        themeManager = ThemeManager()
        
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
