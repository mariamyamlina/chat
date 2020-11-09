//
//  ProfileViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 17.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ProfileViewController: LogViewController {
    // MARK: - UI
    var profileView = ProfileView()
    var currentTheme = Theme.current.themeOptions
    
    // MARK: - Dependencies
    private let presentationAssembly: PresentationAssemblyProtocol
    private let model: ProfileModelProtocol
    
    required init?(coder: NSCoder) {
//        Loger.printButtonLog(gcdSaveButton, #function)
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: ProfileModelProtocol, presentationAssembly: PresentationAssemblyProtocol) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    static var name: String?
    static var bio: String?
    static var image: UIImage?
    
    static var nameDidChange = false
    static var bioDidChange = false
    static var imageDidChange = false
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
    deinit { removeKeyboardNotifications() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Loger.printButtonLog(profileView.gcdSaveButton, #function)
        setupView()
        createRelationships()
        addKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var viewHeight = view.bounds.height - (navigationController?.navigationBar.bounds.height ?? view.bounds.height - 56) - 70
        if #available(iOS 13.0, *) { } else {
            viewHeight -= 20
        }
        profileView.bioTextView.heightAnchor.constraint(equalToConstant: viewHeight - 385).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Loger.printButtonLog(profileView.gcdSaveButton, #function)
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
            profileView.gcdSaveButtonBottomConstraint?.constant = constant
            profileView.operationSaveButtonBottomConstraint?.constant = constant
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                if isKeyboardShowing {
                    let bottomOffset = CGPoint(x: 0, y: (keyboardFrame?.height ?? 0) - (self.navigationController?.navigationBar.bounds.height ?? 0))
                    if bottomOffset.y > 0 {
                        self.profileView.scrollView.setContentOffset(bottomOffset, animated: true)
                    }
                }
            })
        }
    }
    
    // MARK: - Profile Editing
    
    func saveCompletion(_ succeed: Bool) {
        if succeed {
            profileView.saveSucceedCompletion()
            configureAlert("Data has been successfully saved", nil, false)
        } else {
            configureAlert("Error", "Failed to save data", true)
        }
    }
    
    func loadCompletion() {
        profileView.nameTextView.text = ProfileViewController.name
        profileView.bioTextView.text = ProfileViewController.bio
        profileView.profileImageView.loadImageCompletion()
    }
    
    // MARK: - Views
    
    private func setupView() {
        view.addSubview(profileView)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.topAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        model.loadWithGCD(mustReadBio: true, completion: loadCompletion)
//        model.loadWithOperations(mustReadBio: true, completion: loadCompletion)

        applyTheme()
        setupNavigationBar()
    }
    
    private func createRelationships() {
        profileView.nameTextView.delegate = self
        profileView.bioTextView.delegate = self
        
        profileView.saveButtonHandler = { [weak self, weak model, weak profileView] sender in
            guard let self = self else { return }
            profileView?.disableSomeViews()
            if sender == profileView?.gcdSaveButton {
                profileView?.gcdButtonTapped = true
                model?.saveWithGCD(completion: self.saveCompletion(_:))
            } else {
                profileView?.operationButtonTapped = true
                model?.saveWithOperations(completion: self.saveCompletion(_:))
            }
        }
        
        profileView.actionSheetHandler = { [weak self] in
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
            self?.present(alertController, animated: true, completion: nil)
        }
        
        profileView.closeProfileHandler = { [weak self] in
            let navigationVC = self?.presentingViewController as? UINavigationController
            guard let conversationsListVC = navigationVC?.viewControllers.first as? ConversationsListViewController else { return }
            conversationsListVC.navigationItem.rightBarButtonItem = conversationsListVC.conversationsListView.configureRightBarButtonItem()
            conversationsListVC.updateImageView() 
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    func applyTheme() {
        currentTheme = Theme.current.themeOptions
        if #available(iOS 13.0, *) { } else {
            navigationController?.navigationBar.barStyle = currentTheme.barStyle
            imagePicker.navigationBar.barStyle = currentTheme.barStyle
        }
    }
    
    // MARK: - NavigationBar
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = profileView.leftBarButtonItem
        navigationItem.rightBarButtonItem = profileView.rightBarButtonItem
    }
    
    // MARK: - Alert
    
    func configureAlert(_ title: String, _ message: String?, _ twoActions: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: { [weak profileView] (_: UIAlertAction) in
            guard let unwrView = profileView else { return }
            if title != "Error" {
                if unwrView.gcdButtonTapped {
                    unwrView.gcdButtonTapped = false
                } else if unwrView.operationButtonTapped {
                    unwrView.operationButtonTapped = false
                }
                unwrView.editProfileButton.isEnabled = true
                unwrView.setupEditProfileButtonView(title: "Edit Profile", color: .systemBlue)
                ProfileViewController.nameDidChange = false
                ProfileViewController.bioDidChange = false
                ProfileViewController.imageDidChange = false
            }
        })
        alertController.addAction(cancelAction)
        
        if twoActions {
            let repeatAction = UIAlertAction(title: "Repeat", style: .default, handler: { [weak self, weak model, weak profileView] (_: UIAlertAction) in
                guard let self = self else { return }
                guard let unwrView = profileView else { return }
                if unwrView.gcdButtonTapped {
                    model?.saveWithGCD(completion: self.saveCompletion(_:))
                } else if unwrView.operationButtonTapped {
                    model?.saveWithOperations(completion: self.saveCompletion(_:))
                }
            })
            alertController.addAction(repeatAction)
        }
        
        if #available(iOS 13.0, *) { } else {
            if let subview = alertController.view.subviews.first?.subviews.first?.subviews.first {
                subview.backgroundColor = currentTheme.alertColor
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - ImagePicker, UINavigationControllerDelegate, UIImagePickerControllerDelegate

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let compressData = pickedImage.jpegData(compressionQuality: 0.5) else { return }
            let compressedImage = UIImage(data: compressData)
            profileView.profileImageView.profileImage.image = compressedImage
            profileView.profileImageView.lettersLabel.isHidden = true
            profileView.setSaveButtonsEnable(flag: true)
            ProfileViewController.imageDidChange = true
            ProfileViewController.image = compressedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func presentImagePicker(of type: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            imagePicker.sourceType = type
            present(imagePicker, animated: true, completion: nil)
        } else {
            configureAlert("Error", "Check your device and try later", false)
        }
    }
}

// MARK: - UITextViewDelegate

extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        profileView.setSaveButtonsEnable(flag: true)
        if textView == profileView.nameTextView {
            ProfileViewController.nameDidChange = true
        } else {
            ProfileViewController.bioDidChange = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == profileView.nameTextView {
            ProfileViewController.name = textView.text
        } else {
            ProfileViewController.bio = textView.text
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let numberOfChars = (textView.text as NSString).replacingCharacters(in: range, with: text).count
        if textView == profileView.nameTextView {
            return numberOfChars < 21
        } else if textView == profileView.bioTextView {
            return numberOfChars < 61
        }
        return false
    }
}
