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
    lazy var profileView = ProfileView(theme: model.currentTheme,
                                       name: model.name,
                                       bio: model.bio,
                                       image: model.image)
    
    // MARK: - Dependencies
    private let presentationAssembly: IPresentationAssembly
    private let model: IProfileModel
    private var infoDidChange = [false, false, false]
    
    // MARK: - Init / deinit
    required init?(coder: NSCoder) {
//        Loger.printButtonLog(gcdSaveButton, #function)
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: IProfileModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(model: presentationAssembly.logModel())
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    // MARK: - ImagePicker
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        model.buttonLog(profileView.gcdSaveButton, #function)
        setupView()
        createHandlers()
        addKeyboardNotifications()
        navigationController?.applyTheme(theme: model.currentTheme)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationBarHeight = navigationController?.navigationBar.bounds.height else { return }
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let constant = view.bounds.height - navigationBarHeight - statusBarHeight - 470
        profileView.activateBioTextViewHeightConstraint(with: constant)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.buttonLog(profileView.gcdSaveButton, #function)
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
            let height = (self.navigationController?.navigationBar.bounds.height ?? 0) + UIApplication.shared.statusBarFrame.size.height
            let bottomOffset = CGPoint(x: 0, y: (keyboardFrame?.height ?? 0) - height)
            profileView.animate(isKeyboardShowing: isKeyboardShowing,
                                keyboardHeight: keyboardFrame?.height ?? 0,
                                bottomOffset: bottomOffset)
        }
    }
    
    // MARK: - Profile Editing
    func saveCompletion(nameSaved: Bool, bioSaved: Bool, imageSaved: Bool) {
        infoDidChange = [!nameSaved, !bioSaved, !imageSaved]
        if nameSaved && bioSaved && imageSaved {
            profileView.saveSucceedCompletion(name: model.name, image: model.image)
            configureAlert(model: model,
                           view: profileView,
                           changeInfoIndicator: infoDidChange,
                           completion: saveCompletion(nameSaved:bioSaved:imageSaved:),
                           title: "Data has been successfully saved",
                           message: nil,
                           needsTwoActions: false)
        } else {
            configureAlert(model: model,
                           view: profileView,
                           changeInfoIndicator: infoDidChange,
                           completion: saveCompletion(nameSaved:bioSaved:imageSaved:),
                           title: "Error",
                           message: "Failed to save data",
                           needsTwoActions: true)
        }
    }
    
    func loadCompletion() {
        profileView.nameTextView.text = model.name
        profileView.bioTextView.text = model.bio
        profileView.profileImageView.loadImageCompletion(name: model.name, image: model.image)
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.addSubview(profileView)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        model.loadWithGCD(completion: loadCompletion)
//        model.loadWithOperations(completion: loadCompletion)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = profileView.leftBarButtonItem
        navigationItem.rightBarButtonItem = profileView.rightBarButtonItem
    }
    
    // MARK: - Handlers
    private func createHandlers() {
        navigationController?.view.addGestureRecognizer(profileView.animator.gestureRecognizer)
        
        profileView.nameTextView.delegate = self
        profileView.bioTextView.delegate = self
        
        profileView.saveButtonHandler = { [weak self, weak model, weak profileView] sender in
            guard let self = self else { return }
            profileView?.disableSomeViews()
            if sender == profileView?.gcdSaveButton {
                profileView?.gcdButtonTapped = true
                model?.saveWithGCD(nameDidChange: self.infoDidChange[0],
                                   bioDidChange: self.infoDidChange[1],
                                   imageDidChange: self.infoDidChange[2],
                                   completion: self.saveCompletion)
            } else {
                profileView?.operationButtonTapped = true
                model?.saveWithOperations(nameDidChange: self.infoDidChange[0],
                                          bioDidChange: self.infoDidChange[1],
                                          imageDidChange: self.infoDidChange[2],
                                          completion: self.saveCompletion)
            }
        }
        
        profileView.actionSheetHandler = { [weak self] in
            guard let self = self else { return }
            self.configureImagePickerAlert(model: self.model,
                                           completion: self.presentImagePicker)
        }
        
        profileView.closeProfileHandler = { [weak self] in
            let navigationVC = self?.presentingViewController as? UINavigationController
            guard let conversationsListVC = navigationVC?.viewControllers.first as? ConversationsListViewController else { return }
            conversationsListVC.navigationItem.rightBarButtonItem = conversationsListVC.conversationsListView.configureRightBarButtonItem()
            conversationsListVC.updateProfileImage() 
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - ImagePicker, UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            updateProfileImage(with: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func presentImagePicker(of type: UIImagePickerController.SourceType?) {
        if let unwrType = type {
            if UIImagePickerController.isSourceTypeAvailable(unwrType) {
                imagePicker.sourceType = unwrType
                present(imagePicker, animated: true, completion: nil)
            } else {
                configureAlert(model: model,
                               view: profileView,
                               changeInfoIndicator: infoDidChange,
                               completion: saveCompletion(nameSaved:bioSaved:imageSaved:),
                               title: "Error",
                               message: "Check your device and try later",
                               needsTwoActions: false)
            }
        } else {
            let collectionController = self.presentationAssembly.collectionViewController().embedInNavigationController()
            collectionController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
            self.present(collectionController, animated: true, completion: nil)
        }
    }
    
    func updateProfileImage(with pickedImage: UIImage) {
        profileView.updateProfileImage(with: pickedImage)
        infoDidChange[2] = true
        model.changeImage(for: pickedImage)
    }
}

// MARK: - UITextViewDelegate
extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        profileView.setSaveButtonsEnable(flag: true)
        if textView == profileView.nameTextView {
            infoDidChange[0] = true
        } else {
            infoDidChange[1] = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == profileView.nameTextView {
            model.changeName(for: textView.text)
        } else {
            model.changeBio(for: textView.text)
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
