//
//  ProfileView.swift
//  Chat
//
//  Created by Maria Myamlina on 07.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    // MARK: - Dependencies
    let animator = Animator()
    
    // MARK: - UI
    var theme: Theme
    var name, bio: String?
    var image: UIImage?
    var gcdSaveButtonBottomConstraint, operationSaveButtonBottomConstraint: NSLayoutConstraint?

    var startPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        return scrollView
    }()
    
    lazy var scrollViewContentView: UIView = {
        let scrollViewContentView = UIView()
        scrollView.addSubview(scrollViewContentView)
        scrollViewContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollViewContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollViewContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
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
        nameTextView.topAnchor.constraint(equalTo: editPhotoButton.bottomAnchor).isActive = true
        nameTextView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 14).isActive = true
        nameTextView.bottomAnchor.constraint(equalTo: bioTextView.topAnchor, constant: -20).isActive = true
        nameTextView.leadingAnchor.constraint(greaterThanOrEqualTo: scrollViewContentView.leadingAnchor, constant: 40).isActive = true
        nameTextView.trailingAnchor.constraint(lessThanOrEqualTo: scrollViewContentView.trailingAnchor, constant: -40).isActive = true
        nameTextView.centerXAnchor.constraint(equalTo: scrollViewContentView.centerXAnchor).isActive = true
        nameTextView.widthAnchor.constraint(greaterThanOrEqualToConstant: 240).isActive = true
        nameTextView.heightAnchor.constraint(equalToConstant: 44).isActive = true
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
        bioTextView.centerXAnchor.constraint(equalTo: scrollViewContentView.centerXAnchor).isActive = true
        bioTextView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        return bioTextView
    }()
    
    lazy var profileImageView: ProfileImageView = {
        let profileImageView = ProfileImageView(small: false, name: name, image: image)
        profileImageView.isUserInteractionEnabled = false
        scrollViewContentView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: scrollViewContentView.topAnchor, constant: 7).isActive = true
        profileImageView.trailingAnchor.constraint(equalTo: editPhotoButton.trailingAnchor).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: scrollViewContentView.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 240).isActive = true
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
        setupButtonView(button: gcdSaveButton, title: "GCD Save", color: .systemBlue)
        gcdSaveButton.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 19.0)
        gcdSaveButton.titleLabel?.textAlignment = .center
        gcdSaveButton.layer.cornerRadius = 14
        gcdSaveButton.clipsToBounds = true
        gcdSaveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        addSubview(gcdSaveButton)
        gcdSaveButton.translatesAutoresizingMaskIntoConstraints = false
        gcdSaveButtonBottomConstraint = NSLayoutConstraint(item: gcdSaveButton, attribute: .bottom, relatedBy: .equal,
                                                           toItem: self, attribute: .bottom, multiplier: 1, constant: -30)
        gcdSaveButtonBottomConstraint?.isActive = true
        gcdSaveButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        gcdSaveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        gcdSaveButton.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 10 - 12 - 12) / 2).isActive = true
        gcdSaveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return gcdSaveButton
    }()
    
    lazy var operationSaveButton: ButtonWithTouchSize = {
        let operationSaveButton = ButtonWithTouchSize()
        setupButtonView(button: operationSaveButton, title: "Operation Save", color: .systemBlue)
        operationSaveButton.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 19.0)
        operationSaveButton.titleLabel?.textAlignment = .center
        operationSaveButton.layer.cornerRadius = 14
        operationSaveButton.clipsToBounds = true
        operationSaveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        addSubview(operationSaveButton)
        operationSaveButton.translatesAutoresizingMaskIntoConstraints = false
        operationSaveButtonBottomConstraint = NSLayoutConstraint(item: operationSaveButton, attribute: .bottom, relatedBy: .equal,
                                                                 toItem: self, attribute: .bottom, multiplier: 1, constant: -30)
        operationSaveButtonBottomConstraint?.isActive = true
        operationSaveButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        operationSaveButton.leadingAnchor.constraint(equalTo: gcdSaveButton.trailingAnchor, constant: 10).isActive = true
        operationSaveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        operationSaveButton.widthAnchor.constraint(equalTo: gcdSaveButton.widthAnchor).isActive = true
        operationSaveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
        editProfileButton.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 20).isActive = true
        editProfileButton.bottomAnchor.constraint(equalTo: scrollViewContentView.bottomAnchor, constant: -15).isActive = true
        editProfileButton.centerXAnchor.constraint(equalTo: scrollViewContentView.centerXAnchor).isActive = true
        editProfileButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        editProfileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return editProfileButton
    }()
    
    lazy var editPhotoButton: ButtonWithTouchSize = {
        let editPhotoButton = ButtonWithTouchSize()
        setupButtonView(button: editPhotoButton, title: "Edit", color: .systemBlue)
        editPhotoButton.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 16.0)
        editPhotoButton.titleLabel?.textAlignment = .center
        editPhotoButton.addTarget(self, action: #selector(configureActionSheet), for: .touchUpInside)
        scrollViewContentView.addSubview(editPhotoButton)
        editPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        editPhotoButton.leadingAnchor.constraint(greaterThanOrEqualTo: scrollViewContentView.leadingAnchor, constant: 30).isActive = true
        editPhotoButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        editPhotoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return editPhotoButton
    }()
    
    lazy var leftBarButtonItem: UIBarButtonItem = {
        let leftViewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 115, height: 22))
        leftViewLabel.text = "My Profile"
        if #available(iOS 13.0, *) { } else {
            leftViewLabel.textColor = theme.settings.textColor
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
        profileImageView.isUserInteractionEnabled = indicator
        if indicator {
            setupButtonView(button: editProfileButton, title: "Cancel Editing", color: .systemRed)
            [nameTextView, bioTextView].forEach { $0.layer.borderWidth = 1.0 }
            profileImageView.isUserInteractionEnabled = true
            startPosition = CGPoint(x: editProfileButton.layer.position.x,
                                    y: editProfileButton.layer.position.y)
            animator.startTrembling(for: editProfileButton, position: startPosition)
        } else {
            setupButtonView(button: editProfileButton, title: "Edit Profile", color: .systemBlue)
            setSaveButtonsEnable(flag: false)
            [nameTextView, bioTextView].forEach { $0.layer.borderWidth = 0.0}
            animator.stopTrembling(for: editProfileButton, position: startPosition)
        }
    }
    
    func animate(isKeyboardShowing: Bool, keyboardHeight: CGFloat, bottomOffset: CGPoint) {
        [gcdSaveButtonBottomConstraint, operationSaveButtonBottomConstraint].forEach {$0?.constant = isKeyboardShowing ? -keyboardHeight - 30 : -30}
        animator.animateKeyboard(animation: { self.layoutIfNeeded() },
                                 completion: { [weak self] (_) in
                                    if isKeyboardShowing, bottomOffset.y > 0 { self?.scrollView.setContentOffset(bottomOffset, animated: true)
                                    }
        })
    }
    
    func activateBioTextViewHeightConstraint(with constant: CGFloat) { bioTextView.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func saveSucceedCompletion(name: String?, image: UIImage?) {
        self.name = name
        self.image = image
        activityIndicator.stopAnimating()
        profileImageView.loadImageCompletion(name: name, image: image)
        editProfileButton.isEnabled = true
        setupButtonView(button: editProfileButton, title: "Edit Profile", color: .systemBlue)
    }
    
    func updateProfileImage(with image: UIImage) {
        profileImageView.profileImage.image = image
        profileImageView.lettersLabel.isHidden = true
        setSaveButtonsEnable(flag: true)
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
        setupButtonView(button: editProfileButton, title: "Edit Profile", color: .systemBlue)
    }
    
    // MARK: - Setup View
    func setupButtonView(button: ButtonWithTouchSize, title: String, color: UIColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(color.withAlphaComponent(0.4), for: .highlighted)
        button.setTitleColor(.lightGray, for: .disabled)
    }
    
    func disableSomeViews() {
        editProfileButton.isEnabled = false
        activityIndicator.startAnimating()
        [nameTextView, bioTextView].forEach { $0?.layer.borderWidth = 0 }
        setSaveButtonsEnable(flag: false)
        setTextViewsEditable(flag: false)
        animator.stopTrembling(for: editProfileButton, position: startPosition)
    }
    
    private func setTextViewsEditable(flag: Bool) {
        [nameTextView, bioTextView].forEach { $0.isEditable = flag }
        editPhotoButton.isEnabled = flag
    }
    
    func setSaveButtonsEnable(flag: Bool) {
        [gcdSaveButton, operationSaveButton].forEach { $0.isEnabled = flag }
        if !flag {
            [nameTextView, bioTextView].forEach { $0.resignFirstResponder() }
        }
    }
    
    func applyTheme(theme: Theme) {
        self.theme = theme
        [self, scrollViewContentView].forEach { $0?.backgroundColor = theme.settings.backgroundColor }
        [nameTextView, bioTextView].forEach { $0?.textColor = theme.settings.textColor }
        activityIndicator.color = theme.settings.textColor
        [gcdSaveButton, operationSaveButton, editProfileButton].forEach { $0?.backgroundColor = theme.settings.saveButtonColor }
        if #available(iOS 13.0, *) { } else {
            [nameTextView, bioTextView].forEach { $0?.keyboardAppearance = theme.settings.keyboardAppearance }
        }
    }
}
