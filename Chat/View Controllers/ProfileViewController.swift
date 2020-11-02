//
//  ProfileViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 17.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ProfileViewController: LogViewController {
    static var name: String?
    static var bio: String?
    static var image: UIImage?
    
    static var nameDidChange = false
    static var bioDidChange = false
    static var imageDidChange = false
    
    var gcdButtonTapped = false
    var operationButtonTapped = false

    var gcdSaveButtonBottomConstraint: NSLayoutConstraint?
    var operationSaveButtonBottomConstraint: NSLayoutConstraint?
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var scrollViewContentView: UIView = { return UIView() }()
    
    lazy var nameTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        textView.autocapitalizationType = .words
        textView.text = ProfileViewController.name ?? "Marina Dudarenko"
        textView.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        textView.autocorrectionType = .no
        textView.backgroundColor = view.backgroundColor
        textView.layer.cornerRadius = 14
        textView.clipsToBounds = true
        return textView
    }()
    
    lazy var bioTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.textAlignment = .left
        textView.autocapitalizationType = .sentences
        textView.textAlignment = .left
        textView.text = ProfileViewController.bio ?? "UX/UI designer, web-designer" + "\n" + "Moscow, Russia"
        textView.font = UIFont(name: "SFProText-Regular", size: 16)
        textView.autocorrectionType = .no
        textView.backgroundColor = view.backgroundColor
        textView.layer.cornerRadius = 14
        textView.clipsToBounds = true
        return textView
    }()
    
    lazy var profileImageView: ProfileImageView = { return ProfileImageView(small: false) }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .gray
        spinner.hidesWhenStopped = true
        spinner.stopAnimating()
        return spinner
    }()
    
    lazy var gcdSaveButton: ButtonWithTouchSize = {
        let button = ButtonWithTouchSize()
        button.setTitle("GCD Save", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 19.0)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(gcdSaveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var operationSaveButton: ButtonWithTouchSize = {
        let button = ButtonWithTouchSize()
        button.setTitle("Operation Save", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 19.0)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(operationSaveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var editProfileButton: ButtonWithTouchSize = {
        let button = ButtonWithTouchSize()
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 19.0)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var editPhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 16.0)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(configureActionSheet), for: .touchUpInside)
        return button
    }()
    
    deinit {
        removeKeyboardNotifications()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        Loger.printButtonLog(gcdSaveButton, #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Loger.printButtonLog(gcdSaveButton, #function)
        setupViews()
        addKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var viewHeight = view.bounds.height - (navigationController?.navigationBar.bounds.height ?? view.bounds.height - 56) - 70
        if #available(iOS 13.0, *) { } else {
            viewHeight -= 20
        }
        bioTextView.heightAnchor.constraint(equalToConstant: viewHeight - 385).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Loger.printButtonLog(gcdSaveButton, #function)
    }
    
    // MARK: - Keyboard
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyBoardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification

            let constant = isKeyboardShowing ? -(keyboardFrame?.height ?? 0) - 20 : -20
            gcdSaveButtonBottomConstraint?.constant = constant
            operationSaveButtonBottomConstraint?.constant = constant
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                if isKeyboardShowing {
                    let bottomOffset = CGPoint(x: 0, y: (keyboardFrame?.height ?? 0) - (self.navigationController?.navigationBar.bounds.height ?? 0))
                    if bottomOffset.y > 0 {
                        self.scrollView.setContentOffset(bottomOffset, animated: true)
                    }
                }
            })
        }
    }
    
    // MARK: - Theme
    
    func applyTheme() {
        let currentTheme = Theme.current.themeOptions
        [view, scrollViewContentView].forEach { $0?.backgroundColor = currentTheme.backgroundColor }
        [nameTextView, bioTextView].forEach { $0?.textColor = currentTheme.textColor }
        activityIndicator.color = currentTheme.textColor
        [gcdSaveButton, operationSaveButton, editProfileButton].forEach { $0?.backgroundColor = currentTheme.saveButtonColor }
        if #available(iOS 13.0, *) { } else {
            [nameTextView, bioTextView].forEach { $0?.keyboardAppearance = currentTheme.keyboardAppearance }
        }
    }
    
    func applyThemeForImagePicker() {
        if #available(iOS 13.0, *) {
        } else {
            let currentTheme = Theme.current.themeOptions
            self.imagePicker.navigationBar.barStyle = currentTheme.barStyle
        }
    }
    
    // MARK: - Profile Editing
    
    func saveCompletion(_ succeed: Result) {
        if succeed == .success {
            activityIndicator.stopAnimating()
            profileImageView.loadImageCompletion(true, true, true)
            configureAlert("Data has been successfully saved", nil, false)
            editProfileButton.isEnabled = true
            setupEditProfileButtonView(title: "Edit Profile", color: .systemBlue)
        } else {
            configureAlert("Error", "Failed to save data", true)
        }
    }
    
    func loadCompletion(_ mustOverwriteName: Bool, _ mustOverwriteBio: Bool, _ mustOverwriteImage: Bool) {
        if mustOverwriteName {
            nameTextView.text = ProfileViewController.name
        }
        if mustOverwriteBio {
            bioTextView.text = ProfileViewController.bio
        }
        if mustOverwriteImage {
            profileImageView.updateImage()
        }
    }
    
    func referToFile(action: ActionType, dataManager: DataManagerProtocol) {
        if action == .load {
            dataManager.loadFromFile(mustReadName: true, mustReadBio: true, mustReadImage: true, completion: loadCompletion(_:_:_:))
            loadCompletion(true, true, true)
        } else {
            dataManager.saveToFile(completion: saveCompletion(_:))
        }
    }
    
    // MARK: - Views
    
    private func setupViews() {
        view.addSubview(scrollView)
        view.addSubview(gcdSaveButton)
        view.addSubview(operationSaveButton)
        scrollView.addSubview(scrollViewContentView)
        scrollViewContentView.addSubview(editProfileButton)
        scrollViewContentView.addSubview(activityIndicator)
        scrollViewContentView.addSubview(nameTextView)
        scrollViewContentView.addSubview(bioTextView)
        scrollViewContentView.addSubview(profileImageView)
        scrollViewContentView.addSubview(editPhotoButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        gcdSaveButton.translatesAutoresizingMaskIntoConstraints = false
        operationSaveButton.translatesAutoresizingMaskIntoConstraints = false
        scrollViewContentView.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        nameTextView.translatesAutoresizingMaskIntoConstraints = false
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        editPhotoButton.translatesAutoresizingMaskIntoConstraints = false

        gcdSaveButtonBottomConstraint = NSLayoutConstraint(item: gcdSaveButton, attribute: .bottom, relatedBy: .equal,
                                                           toItem: view, attribute: .bottom, multiplier: 1, constant: -20)
        operationSaveButtonBottomConstraint = NSLayoutConstraint(item: operationSaveButton, attribute: .bottom, relatedBy: .equal,
                                                                 toItem: view, attribute: .bottom, multiplier: 1, constant: -20)
        gcdSaveButtonBottomConstraint?.isActive = true
        operationSaveButtonBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            editProfileButton.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 20),
            editProfileButton.bottomAnchor.constraint(equalTo: scrollViewContentView.bottomAnchor),
            editProfileButton.leadingAnchor.constraint(greaterThanOrEqualTo: scrollViewContentView.leadingAnchor, constant: 12),
            editProfileButton.trailingAnchor.constraint(lessThanOrEqualTo: scrollViewContentView.trailingAnchor, constant: -12),
            editProfileButton.centerXAnchor.constraint(equalTo: scrollViewContentView.centerXAnchor),
            editProfileButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 296),
            editProfileButton.heightAnchor.constraint(equalToConstant: 40),
            activityIndicator.topAnchor.constraint(equalTo: nameTextView.bottomAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: bioTextView.topAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: scrollViewContentView.centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 20),
            activityIndicator.heightAnchor.constraint(equalToConstant: 20),
            nameTextView.topAnchor.constraint(equalTo: editPhotoButton.bottomAnchor),
            nameTextView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 14),
            nameTextView.bottomAnchor.constraint(equalTo: bioTextView.topAnchor, constant: -20),
            nameTextView.leadingAnchor.constraint(greaterThanOrEqualTo: scrollViewContentView.leadingAnchor, constant: 40),
            nameTextView.trailingAnchor.constraint(lessThanOrEqualTo: scrollViewContentView.trailingAnchor, constant: -40),
            nameTextView.centerXAnchor.constraint(equalTo: scrollViewContentView.centerXAnchor),
            nameTextView.widthAnchor.constraint(greaterThanOrEqualToConstant: 240),
            nameTextView.heightAnchor.constraint(equalToConstant: 44),
            profileImageView.topAnchor.constraint(equalTo: scrollViewContentView.topAnchor, constant: 7),
            profileImageView.trailingAnchor.constraint(equalTo: editPhotoButton.trailingAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: scrollViewContentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 240),
            profileImageView.heightAnchor.constraint(equalToConstant: 240),
            editPhotoButton.leadingAnchor.constraint(greaterThanOrEqualTo: scrollViewContentView.leadingAnchor, constant: 30),
            editPhotoButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
            editPhotoButton.heightAnchor.constraint(equalToConstant: 40),
            bioTextView.centerXAnchor.constraint(equalTo: scrollViewContentView.centerXAnchor),
            bioTextView.widthAnchor.constraint(equalToConstant: 240),
            operationSaveButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            operationSaveButton.leadingAnchor.constraint(equalTo: gcdSaveButton.trailingAnchor, constant: 10),
            operationSaveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            operationSaveButton.widthAnchor.constraint(equalTo: gcdSaveButton.widthAnchor),
            operationSaveButton.heightAnchor.constraint(equalToConstant: 40),
            gcdSaveButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            gcdSaveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            gcdSaveButton.widthAnchor.constraint(equalTo: operationSaveButton.widthAnchor),
            gcdSaveButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        referToFile(action: .load, dataManager: GCDDataManager.shared)
//        referToFile(action: .load, dataManager: OperationDataManager.shared)

        applyTheme()
        setupNavigationBar()
        setTextViewsEditable(flag: false)
        setupEditProfileButtonView(title: "Edit Profile", color: .systemBlue)
        setSaveButtonsEnable(flag: false)
    }
    
    private func setupEditProfileButtonView(title: String, color: UIColor) {
        editProfileButton.setTitle(title, for: .normal)
        editProfileButton.setTitleColor(color, for: .normal)
        editProfileButton.setTitleColor(.lightGray, for: .disabled)
    }
    
    private func disableSomeViews() {
        editProfileButton.isEnabled = false
        activityIndicator.startAnimating()
        [nameTextView, bioTextView].forEach { $0?.layer.borderWidth = 0 }
        setSaveButtonsEnable(flag: false)
        setTextViewsEditable(flag: false)
    }
    
    private func setTextViewsEditable(flag: Bool) {
        nameTextView.isEditable = flag
        bioTextView.isEditable = flag
        editPhotoButton.isEnabled = flag
    }
    
    func setSaveButtonsEnable(flag: Bool) {
        gcdSaveButton.isEnabled = flag
        operationSaveButton.isEnabled = flag
    }
    
    // MARK: - Navigation
    
    private func setupNavigationBar() {
        let leftViewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 115, height: 22))
        leftViewLabel.text = "My Profile"
        if #available(iOS 13.0, *) { } else {
            let currentTheme = Theme.current.themeOptions
            navigationController?.navigationBar.barStyle = currentTheme.barStyle
            leftViewLabel.textColor = currentTheme.textColor
        }
        leftViewLabel.font = UIFont(name: "SFProDisplay-Bold", size: 26)
        let leftItem = UIBarButtonItem(customView: leftViewLabel)
        navigationItem.leftBarButtonItem = leftItem
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeProfileViewController))
        let attr = [NSAttributedString.Key.font: UIFont(name: "SFProText-Semibold", size: 17) as Any]
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(attr, for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(attr, for: .highlighted)
    }
    
    @objc private func closeProfileViewController() {
        let navigationVC = self.presentingViewController as? UINavigationController
        let conversationsListVC = navigationVC?.viewControllers.first as? ConversationsListViewController
        conversationsListVC?.setupRightBarButton()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func gcdSaveButtonTapped() {
        gcdButtonTapped = true
        disableSomeViews()
        referToFile(action: .save, dataManager: GCDDataManager.shared)
    }
    
    @objc func operationSaveButtonTapped() {
        operationButtonTapped = true
        disableSomeViews()
        referToFile(action: .save, dataManager: OperationDataManager.shared)
    }
    
    @objc func editProfileButtonTapped() {
        if editProfileButton.titleLabel?.text == "Edit Profile" {
            setupEditProfileButtonView(title: "Cancel Editing", color: .systemRed)
            setTextViewsEditable(flag: true)
            [nameTextView, bioTextView].forEach {
                $0.layer.borderWidth = 1.0
                $0.layer.borderColor = Colors.tableViewLightSeparatorColor.cgColor
            }
        } else {
            setupEditProfileButtonView(title: "Edit Profile", color: .systemBlue)
            setTextViewsEditable(flag: false)
            setSaveButtonsEnable(flag: false)
            [nameTextView, bioTextView].forEach {
                $0.layer.borderWidth = 0.0
            }
        }
    }
    
    // MARK: - Alert
    
    @objc private func configureActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.pruneNegativeWidthConstraints()
        let galeryAction = UIAlertAction(title: "Choose from gallery", style: .default) { [weak self] (_) in
            self?.presentImagePicker(of: .photoLibrary)
        }
        let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default) { [weak self] (_) in
            self?.presentImagePicker(of: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
        [galeryAction, takePhotoAction, cancelAction].forEach { alertController.addAction($0) }
        if #available(iOS 13.0, *) { } else {
            if let subview = alertController.view.subviews.first?.subviews.first?.subviews.first {
                let currentTheme = Theme.current.themeOptions
                subview.backgroundColor = currentTheme.alertColor
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func configureAlert(_ title: String, _ message: String?, _ twoActions: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] (_: UIAlertAction) in
            guard let self = self else { return }
            if title != "Error" {
                if self.gcdButtonTapped {
                    self.gcdButtonTapped = false
                } else if self.operationButtonTapped {
                    self.operationButtonTapped = false
                }
                self.editProfileButton.isEnabled = true
                self.setupEditProfileButtonView(title: "Edit Profile", color: .systemBlue)
                ProfileViewController.nameDidChange = false
                ProfileViewController.bioDidChange = false
                ProfileViewController.imageDidChange = false
            }
        })
        alertController.addAction(cancelAction)
        
        if twoActions {
            let repeatAction = UIAlertAction(title: "Repeat", style: .default, handler: { [weak self] (_: UIAlertAction) in
                guard let self = self else { return }
                if self.gcdButtonTapped {
                    self.referToFile(action: .save, dataManager: GCDDataManager.shared)
                } else if self.operationButtonTapped {
                    self.referToFile(action: .save, dataManager: OperationDataManager.shared)
                }
            })
            alertController.addAction(repeatAction)
        }
        
        if #available(iOS 13.0, *) { } else {
            if let subview = alertController.view.subviews.first?.subviews.first?.subviews.first {
                let currentTheme = Theme.current.themeOptions
                subview.backgroundColor = currentTheme.alertColor
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
