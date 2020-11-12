//
//  ProfileView.swift
//  Chat
//
//  Created by Maria Myamlina on 07.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    // MARK: - UI
    var theme: Theme
    var name, bio: String?
    var image: UIImage?
    var gcdSaveButtonBottomConstraint, operationSaveButtonBottomConstraint: NSLayoutConstraint?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        return scrollView
    }()
    
    lazy var scrollViewContentView: UIView = {
        let scrollViewContentView = UIView()
        scrollView.addSubview(scrollViewContentView)
        scrollViewContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollViewContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        return scrollViewContentView
    }()
    
    lazy var nameTextView: UITextView = {
        let nameTextView = UITextView()
        nameTextView.textAlignment = .center
        nameTextView.isScrollEnabled = false
        nameTextView.autocapitalizationType = .words
        nameTextView.text = name ?? "Marina Dudarenko"
        nameTextView.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        nameTextView.autocorrectionType = .no
        nameTextView.backgroundColor = backgroundColor
        nameTextView.layer.borderColor = Colors.tableViewLightSeparatorColor.cgColor
        nameTextView.layer.cornerRadius = 14
        nameTextView.clipsToBounds = true
        scrollViewContentView.addSubview(nameTextView)
        nameTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextView.topAnchor.constraint(equalTo: editPhotoButton.bottomAnchor),
            nameTextView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 14),
            nameTextView.bottomAnchor.constraint(equalTo: bioTextView.topAnchor, constant: -20),
            nameTextView.leadingAnchor.constraint(greaterThanOrEqualTo: scrollViewContentView.leadingAnchor, constant: 40),
            nameTextView.trailingAnchor.constraint(lessThanOrEqualTo: scrollViewContentView.trailingAnchor, constant: -40),
            nameTextView.centerXAnchor.constraint(equalTo: scrollViewContentView.centerXAnchor),
            nameTextView.widthAnchor.constraint(greaterThanOrEqualToConstant: 240),
            nameTextView.heightAnchor.constraint(equalToConstant: 44)
        ])
        return nameTextView
    }()
    
    lazy var bioTextView: UITextView = {
        let bioTextView = UITextView()
        bioTextView.textAlignment = .left
        bioTextView.autocapitalizationType = .sentences
        bioTextView.text = bio ?? "UX/UI designer, web-designer" + "\n" + "Moscow, Russia"
        bioTextView.font = UIFont(name: "SFProText-Regular", size: 16)
        bioTextView.autocorrectionType = .no
        bioTextView.backgroundColor = backgroundColor
        bioTextView.layer.borderColor = Colors.tableViewLightSeparatorColor.cgColor
        bioTextView.layer.cornerRadius = 14
        bioTextView.clipsToBounds = true
        scrollViewContentView.addSubview(bioTextView)
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bioTextView.centerXAnchor.constraint(equalTo: scrollViewContentView.centerXAnchor),
            bioTextView.widthAnchor.constraint(equalToConstant: 240)
        ])
        return bioTextView
    }()
    
    lazy var profileImageView: ProfileImageView = {
        let profileImageView = ProfileImageView(small: false, name: name, image: image)
        scrollViewContentView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: scrollViewContentView.topAnchor, constant: 7),
            profileImageView.trailingAnchor.constraint(equalTo: editPhotoButton.trailingAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: scrollViewContentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 240),
            profileImageView.heightAnchor.constraint(equalToConstant: 240)
        ])
        return profileImageView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        scrollViewContentView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    lazy var gcdSaveButton: ButtonWithTouchSize = {
        let gcdSaveButton = ButtonWithTouchSize()
        gcdSaveButton.setTitle("GCD Save", for: .normal)
        setup(button: gcdSaveButton)
        gcdSaveButton.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 19.0)
        gcdSaveButton.titleLabel?.textAlignment = .center
        gcdSaveButton.layer.cornerRadius = 14
        gcdSaveButton.clipsToBounds = true
        gcdSaveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        addSubview(gcdSaveButton)
        gcdSaveButton.translatesAutoresizingMaskIntoConstraints = false
        gcdSaveButtonBottomConstraint = NSLayoutConstraint(item: gcdSaveButton, attribute: .bottom, relatedBy: .equal,
                                                           toItem: self, attribute: .bottom, multiplier: 1, constant: -20)
        gcdSaveButtonBottomConstraint?.isActive = true
        NSLayoutConstraint.activate([
            gcdSaveButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            gcdSaveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            gcdSaveButton.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 10 - 12 - 12) / 2),
            gcdSaveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        return gcdSaveButton
    }()
    
    lazy var operationSaveButton: ButtonWithTouchSize = {
        let operationSaveButton = ButtonWithTouchSize()
        operationSaveButton.setTitle("Operation Save", for: .normal)
        setup(button: operationSaveButton)
        operationSaveButton.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 19.0)
        operationSaveButton.titleLabel?.textAlignment = .center
        operationSaveButton.layer.cornerRadius = 14
        operationSaveButton.clipsToBounds = true
        operationSaveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        addSubview(operationSaveButton)
        operationSaveButton.translatesAutoresizingMaskIntoConstraints = false
        operationSaveButtonBottomConstraint = NSLayoutConstraint(item: operationSaveButton, attribute: .bottom, relatedBy: .equal,
                                                                 toItem: self, attribute: .bottom, multiplier: 1, constant: -20)
        operationSaveButtonBottomConstraint?.isActive = true
        NSLayoutConstraint.activate([
            operationSaveButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            operationSaveButton.leadingAnchor.constraint(equalTo: gcdSaveButton.trailingAnchor, constant: 10),
            operationSaveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            operationSaveButton.widthAnchor.constraint(equalTo: gcdSaveButton.widthAnchor),
            operationSaveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        return operationSaveButton
    }()
    
    lazy var editProfileButton: ButtonWithTouchSize = {
        let editProfileButton = ButtonWithTouchSize()
        editProfileButton.setTitle("Edit Profile", for: .normal)
        editProfileButton.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 19.0)
        editProfileButton.titleLabel?.textAlignment = .center
        editProfileButton.layer.cornerRadius = 14
        editProfileButton.clipsToBounds = true
        editProfileButton.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        scrollViewContentView.addSubview(editProfileButton)
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editProfileButton.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 20),
            editProfileButton.bottomAnchor.constraint(equalTo: scrollViewContentView.bottomAnchor),
            editProfileButton.leadingAnchor.constraint(greaterThanOrEqualTo: scrollViewContentView.leadingAnchor, constant: 12),
            editProfileButton.trailingAnchor.constraint(lessThanOrEqualTo: scrollViewContentView.trailingAnchor, constant: -12),
            editProfileButton.centerXAnchor.constraint(equalTo: scrollViewContentView.centerXAnchor),
            editProfileButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 296),
            editProfileButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        return editProfileButton
    }()
    
    lazy var editPhotoButton: UIButton = {
        let editPhotoButton = UIButton()
        editPhotoButton.setTitle("Edit", for: .normal)
        setup(button: editPhotoButton)
        editPhotoButton.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 16.0)
        editPhotoButton.titleLabel?.textAlignment = .center
        editPhotoButton.addTarget(self, action: #selector(configureActionSheet), for: .touchUpInside)
        scrollViewContentView.addSubview(editPhotoButton)
        editPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editPhotoButton.leadingAnchor.constraint(greaterThanOrEqualTo: scrollViewContentView.leadingAnchor, constant: 30),
            editPhotoButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
            editPhotoButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        return editPhotoButton
    }()
    
    lazy var leftBarButtonItem: UIBarButtonItem = {
        let leftViewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 115, height: 22))
        leftViewLabel.text = "My Profile"
        if #available(iOS 13.0, *) { } else {
            leftViewLabel.textColor = theme.themeSettings.textColor
        }
        leftViewLabel.font = UIFont(name: "SFProDisplay-Bold", size: 26)
        return UIBarButtonItem(customView: leftViewLabel)
    }()
    
    lazy var rightBarButtonItem: UIBarButtonItem = {
        let rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeProfileViewController))
        let attr = [NSAttributedString.Key.font: UIFont(name: "SFProText-Semibold", size: 17) as Any]
        rightBarButtonItem.setTitleTextAttributes(attr, for: .normal)
        rightBarButtonItem.setTitleTextAttributes(attr, for: .highlighted)
        return rightBarButtonItem
    }()
    
    // MARK: - Handlers
    var saveButtonHandler: ((ButtonWithTouchSize) -> Void)?
    var actionSheetHandler, closeProfileHandler: (() -> Void)?
    @objc func saveButtonTapped(_ sender: ButtonWithTouchSize) { saveButtonHandler?(sender) }
    @objc func configureActionSheet() { actionSheetHandler?() }
    @objc func closeProfileViewController() { closeProfileHandler?() }
    var gcdButtonTapped = false
    var operationButtonTapped = false
    
    @objc func editProfileButtonTapped() {
        let indicator = editProfileButton.titleLabel?.text == "Edit Profile"
        setTextViewsEditable(flag: indicator)
        if indicator {
            setupEditProfileButtonView(title: "Cancel Editing", color: .systemRed)
            [nameTextView, bioTextView].forEach { $0.layer.borderWidth = 1.0 }
        } else {
            setupEditProfileButtonView(title: "Edit Profile", color: .systemBlue)
            setSaveButtonsEnable(flag: false)
            [nameTextView, bioTextView].forEach { $0.layer.borderWidth = 0.0}
        }
    }
    
    func animate(isKeyboardShowing: Bool, keyboardHeight: CGFloat, bottomOffset: CGPoint) {
        [gcdSaveButtonBottomConstraint, operationSaveButtonBottomConstraint].forEach {$0?.constant = isKeyboardShowing ? -keyboardHeight - 20 : -20}
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: { self.layoutIfNeeded() },
                       completion: { [weak self] (_) in
            if isKeyboardShowing, bottomOffset.y > 0 { self?.scrollView.setContentOffset(bottomOffset, animated: true) }
        })
    }
    
    func activateBioTextViewHeightConstraint(with constant: CGFloat) {
        var height = constant
        if #available(iOS 13.0, *) { } else { height -= 20 }
        bioTextView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(theme: Theme, name: String?, bio: String?, image: UIImage?) {
        self.theme = theme
        self.name = name
        self.bio = bio
        self.image = image
        super.init(frame: CGRect(origin: UIScreen.main.bounds.origin, size: UIScreen.main.bounds.size))
        applyTheme(theme: theme)
        setTextViewsEditable(flag: false)
        setSaveButtonsEnable(flag: false)
        setupEditProfileButtonView(title: "Edit Profile", color: .systemBlue)
    }
    
    // MARK: - Setup View
    func setupEditProfileButtonView(title: String, color: UIColor) {
        editProfileButton.setTitle(title, for: .normal)
        editProfileButton.setTitleColor(color, for: .normal)
        editProfileButton.setTitleColor(color.withAlphaComponent(0.4), for: .highlighted)
        editProfileButton.setTitleColor(.lightGray, for: .disabled)
    }
    
    func disableSomeViews() {
        editProfileButton.isEnabled = false
        activityIndicator.startAnimating()
        [nameTextView, bioTextView].forEach { $0?.layer.borderWidth = 0 }
        setSaveButtonsEnable(flag: false)
        setTextViewsEditable(flag: false)
    }
    
    private func setTextViewsEditable(flag: Bool) {
        [nameTextView, nameTextView].forEach { $0.isEditable = flag }
        editPhotoButton.isEnabled = flag
    }
    
    func setSaveButtonsEnable(flag: Bool) {
        [gcdSaveButton, operationSaveButton].forEach { $0.isEnabled = flag }
    }
    
    func saveSucceedCompletion(name: String?, image: UIImage?) {
        self.name = name
        self.image = image
        activityIndicator.stopAnimating()
        profileImageView.loadImageCompletion(name: name, image: image)
        editProfileButton.isEnabled = true
        setupEditProfileButtonView(title: "Edit Profile", color: .systemBlue)
    }
    
    func applyTheme(theme: Theme) {
        self.theme = theme
        [self, scrollViewContentView].forEach { $0?.backgroundColor = theme.themeSettings.backgroundColor }
        [nameTextView, bioTextView].forEach { $0?.textColor = theme.themeSettings.textColor }
        activityIndicator.color = theme.themeSettings.textColor
        [gcdSaveButton, operationSaveButton, editProfileButton].forEach { $0?.backgroundColor = theme.themeSettings.saveButtonColor }
        if #available(iOS 13.0, *) { } else {
            [nameTextView, bioTextView].forEach { $0?.keyboardAppearance = theme.themeSettings.keyboardAppearance }
        }
    }
    
    func updateProfileImage(with image: UIImage) {
        profileImageView.profileImage.image = image
        profileImageView.lettersLabel.isHidden = true
        setSaveButtonsEnable(flag: true)
    }
    
    func setup(button: UIButton) {
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.4), for: .highlighted)
        button.setTitleColor(.lightGray, for: .disabled)
    }
}
