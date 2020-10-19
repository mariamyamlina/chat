//
//  ProfileViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 17.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ProfileViewController: LogViewController {
    var imagePicker: UIImagePickerController!
    
    static var nameDidChange = false
    static var bioDidChange = false
    static var imageDidChange = false
    
    static var gcdButtonTapped = false
    static var operationButtonTapped = false
    
    static var name: String?
    static var bio: String?
    static var image: UIImage?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContentView: UIView!
    
    @IBOutlet weak var gcdSaveButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var gcdSaveButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var operationSaveButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var operationSaveButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bioTextViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var gcdSaveButton: ButtonWithTouchSize!
    @IBOutlet weak var operationSaveButton: ButtonWithTouchSize!
    @IBOutlet weak var editProfileButton: ButtonWithTouchSize!
    @IBOutlet weak var editPhotoButton: UIButton!
    
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func GCDSaveButtonTapped(_ sender: ButtonWithTouchSize) {
        ProfileViewController.gcdButtonTapped = true
        enableSomeViews()
        referToFile(action: .write, dataManager: .gcd)
    }
    
    @IBAction func OperationSaveButtonTapped(_ sender: ButtonWithTouchSize) {
        ProfileViewController.operationButtonTapped = true
        enableSomeViews()
        referToFile(action: .write, dataManager: .operation)
    }
    
    @IBAction func editPhotoButtonTapped(_ sender: UIButton) {
        configureActionSheet()
    }
    
    @IBAction func editProfileButtonTapped(_ sender: ButtonWithTouchSize) {
        if editProfileButton.titleLabel?.text == "Edit Profile" {
            setupEditProfileButtonView(title: "Cancel Editing", color: .systemRed)
            setTextViewsEditable(flag: true)
            for textView in [nameTextView, bioTextView] {
                textView?.becomeFirstResponder()
                textView?.layer.borderWidth = 1.0
                textView?.layer.borderColor = Colors.tableViewLightSeparatorColor.cgColor
            }
        } else {
            setupEditProfileButtonView(title: "Edit Profile", color: .systemBlue)
            setTextViewsEditable(flag: false)
            setSaveButtonsEnable(flag: false)
            for textView in [nameTextView, bioTextView] {
                textView?.resignFirstResponder()
                textView?.layer.borderWidth = 0.0
            }
        }
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        /* Loger.printButtonLog(GCDSaveButton, #function)
         Почему возникает ошибка "Unexpectedly found nil while implicitly unwrapping an Optional value".
         View Controller все еще находится в состоянии Unloaded: объект view не создан, IBOutlet и IBAction не назначены.
         Соответственно, переменная saveButton на момент вызова init имеет значение nil, поэтому при косвенном извлечении опционала вылетает error.
         Метод loadView, который срабатывает после init, загружает интерфейсный файл, создает все view, кнопки и прочие элементы в нем,
         а также назначает все связи IBOutlet и IBAction. Завершение настройки происходит в методе viewDidLoad. */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Loger.printButtonLog(gcdSaveButton, #function)

        nameTextView.delegate = self
        bioTextView.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        setupViews()
        setupNavigationBar()
        setupButtonsConstraints()
        addKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var viewHeight = view.bounds.height - (navigationController?.navigationBar.bounds.height ?? view.bounds.height - 56) - 70
        if #available(iOS 13.0, *) { } else {
            viewHeight -= 20
        }
        bioTextViewHeightConstraint.constant = viewHeight - 385
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Loger.printButtonLog(gcdSaveButton, #function)
        /* Почему значения frame отличаются при определенной конфигурации девайсов storyboard/simulator.
        Так как в .storyboard выбран iPhone SE 2, а запускается проект на iPhone 11/iPhone 11 Pro: они имеют разный размер экранов.
        В методе viewDidLoad объект view уже создан, но еще не добавлен в иерархию. Настройка элементов происходит в методе viewWillAppear.
        В состоянии Appearing происходит анимация View Controller в процессе появления. После срабатывает viewDidAppear, при этом view уже имеет свой окончательный внешний вид. */
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

            let constant = isKeyboardShowing ? -(keyboardFrame?.height ?? 20) - 20 : -20
            gcdSaveButtonBottomConstraint?.constant = constant
            operationSaveButtonBottomConstraint?.constant = constant
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                if isKeyboardShowing {
                    let bottomOffset = CGPoint(x: 0, y: keyboardFrame?.height ?? 20)
                    if bottomOffset.y > 0 {
                        self.scrollView.setContentOffset(bottomOffset, animated: true)
                    }
                }
            })
        }
    }
    
    // MARK: - Theme
    
    fileprivate func applyTheme() {
        let currentTheme = Theme.current.themeOptions
        for coloredView in [view, scrollViewContentView] {
            coloredView?.backgroundColor = currentTheme.backgroundColor
        }
        activityIndicator.color = currentTheme.textColor
        for button in [gcdSaveButton, operationSaveButton, editProfileButton] {
            button?.backgroundColor = currentTheme.saveButtonColor
        }
        if #available(iOS 13.0, *) { } else {
            for textView in [nameTextView, bioTextView] {
                textView?.keyboardAppearance = currentTheme.keyboardAppearance
            }
        }
    }
    
    fileprivate func applyThemeForImagePicker() {
        if #available(iOS 13.0, *) {
        } else {
            let currentTheme = Theme.current.themeOptions
            self.imagePicker.navigationBar.barStyle = currentTheme.barStyle
        }
    }
    
    // MARK: - Profile Editing
    
    func loadCompletion(_ succeed: Bool) {
        if succeed {
            activityIndicator.stopAnimating()
            configureAlert("Data has been successfully saved", nil, false)
            editProfileButton.isEnabled = true
            setupEditProfileButtonView(title: "Edit Profile", color: .systemBlue)
        } else {
            configureAlert("Error", "Failed to save data", true)
        }
    }
    
    func uploadCompletion(_ mustOverwriteName: Bool, _ mustOverwriteBio: Bool, _ mustOverwriteImage: Bool) {
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

    func referToFile(action: ActionType, dataManager: DataManagerType) {
        switch dataManager {
        case .gcd:
            if let gcdDataManager: GCDDataManager = DataManager.returnDataManager(of: dataManager) {
                gcdDataManager.profileViewController = self
                if action == .read {
                    gcdDataManager.readFromFile(completion: uploadCompletion(_:_:_:))
                    uploadCompletion(true, true, true)
                } else {
                    gcdDataManager.writeToFile(completion: loadCompletion(_:))
                }
            }
        case .operation:
            if let operationDataManager: OperationDataManager = DataManager.returnDataManager(of: dataManager) {
                operationDataManager.profileViewController = self
                if action == .read {
                    operationDataManager.readFromFile(completion: uploadCompletion(_:_:_:))
                    uploadCompletion(true, true, true)
                } else {
                    operationDataManager.writeToFile(completion: loadCompletion(_:))
                }
            }
        }
    }
    
    // MARK: - Views
    
    private func setupViews() {
        applyTheme()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()

        referToFile(action: .read, dataManager: .gcd)
//        referToFile(action: .read, dataManager: .operation)

        setupTextViews()
        setupButtonViews()
    }
    
    private func setupButtonViews() {
        setupEditProfileButtonView(title: "Edit Profile", color: .systemBlue)
        for button in [editProfileButton, gcdSaveButton, operationSaveButton] {
            button?.layer.cornerRadius = 14
            button?.clipsToBounds = true
        }
        setSaveButtonsEnable(flag: false)
    }
    
    private func setupButtonsConstraints() {
        gcdSaveButtonTopConstraint.isActive = false
        gcdSaveButtonTopConstraint = gcdSaveButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10)
        gcdSaveButtonTopConstraint?.isActive = true

        gcdSaveButtonBottomConstraint.isActive = false
        gcdSaveButtonBottomConstraint = gcdSaveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        gcdSaveButtonBottomConstraint?.isActive = true
        
        operationSaveButtonTopConstraint.isActive = false
        operationSaveButtonTopConstraint = operationSaveButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10)
        operationSaveButtonTopConstraint?.isActive = true

        operationSaveButtonBottomConstraint.isActive = false
        operationSaveButtonBottomConstraint = operationSaveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        operationSaveButtonBottomConstraint?.isActive = true
    }
    
    private func setupTextViews() {
        let currentTheme = Theme.current.themeOptions

        for textView in [nameTextView, bioTextView] {
            var text: String = ""
            if textView == nameTextView {
                textView?.isScrollEnabled = false
                textView?.autocapitalizationType = .words
                textView?.textAlignment = .center
                text = ProfileViewController.name ?? "Marina Dudarenko"
                textView?.font = UIFont(name: "SFProDisplay-Bold", size: 24)
            } else {
                textView?.autocapitalizationType = .sentences
                textView?.textAlignment = .left
                text = ProfileViewController.bio ?? "UX/UI designer, web-designer" + "\n" + "Moscow, Russia"
                textView?.font = UIFont(name: "SFProText-Regular", size: 16)
            }
            textView?.text = text
            textView?.autocorrectionType = .no
            textView?.backgroundColor = view.backgroundColor
            textView?.textColor = currentTheme.textColor
            textView?.layer.cornerRadius = 14
            textView?.clipsToBounds = true
        }
        setTextViewsEditable(flag: false)
    }
    
    private func setupEditProfileButtonView(title: String, color: UIColor) {
        editProfileButton.setTitle(title, for: .normal)
        editProfileButton.setTitleColor(color, for: .normal)
        editProfileButton.setTitleColor(.lightGray, for: .disabled)
    }
    
    private func enableSomeViews() {
        editProfileButton.isEnabled = false
        activityIndicator.startAnimating()
        for textView in [nameTextView, bioTextView] {
            textView?.layer.borderWidth = 0
        }
        setSaveButtonsEnable(flag: false)
        setTextViewsEditable(flag: false)
    }
    
    private func setTextViewsEditable(flag: Bool) {
        nameTextView.isEditable = flag
        bioTextView.isEditable = flag
        editPhotoButton.isEnabled = flag
    }
    
    private func setSaveButtonsEnable(flag: Bool) {
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
        conversationsListVC?.updateProfileImageView()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Alert
    
    private func configureActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.pruneNegativeWidthConstraints()
        let galeryAction = UIAlertAction(title: "Choose from gallery", style: .default) { (_) in
            self.presentImagePicker(of: .photoLibrary)
        }
        let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default) { (_) in
            self.presentImagePicker(of: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
        for action in [galeryAction, takePhotoAction, cancelAction] {
            alertController.addAction(action)
        }
        if #available(iOS 13.0, *) { } else {
            if let subview = alertController.view.subviews.first?.subviews.first?.subviews.first {
                let currentTheme = Theme.current.themeOptions
                subview.backgroundColor = currentTheme.alertColor
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func configureAlert(_ title: String, _ message: String?, _ twoActions: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: {(_: UIAlertAction) in
            if title != "Error" {
                if ProfileViewController.gcdButtonTapped {
                    ProfileViewController.gcdButtonTapped = false
                } else if ProfileViewController.operationButtonTapped {
                    ProfileViewController.operationButtonTapped = false
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
            let repeatAction = UIAlertAction(title: "Repeat", style: .default, handler: {(_: UIAlertAction) in
                if ProfileViewController.gcdButtonTapped {
                    self.referToFile(action: .write, dataManager: .gcd)
                } else if ProfileViewController.operationButtonTapped {
                    self.referToFile(action: .write, dataManager: .operation)
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

// MARK: - ImagePicker, UINavigationControllerDelegate, UIImagePickerControllerDelegate

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let compressData = pickedImage.jpegData(compressionQuality: 0.5) else { return }
            let compressedImage = UIImage(data: compressData)

            profileImageView.profileImage.image = compressedImage
            profileImageView.lettersLabel.isHidden = true

            setSaveButtonsEnable(flag: true)

            ProfileViewController.imageDidChange = true
            ProfileViewController.image = compressedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func presentImagePicker(of type: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            imagePicker.sourceType = type
            applyThemeForImagePicker()
            present(imagePicker, animated: true, completion: nil)
        } else {
            configureAlert("Error", "Check your device and try later", false)
        }
    }
}

// MARK: - UITextViewDelegate

extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        setSaveButtonsEnable(flag: true)
        if textView == nameTextView {
            ProfileViewController.nameDidChange = true
        } else {
            ProfileViewController.bioDidChange = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == nameTextView {
            ProfileViewController.name = textView.text
        } else {
            ProfileViewController.bio = textView.text
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let numberOfChars = (textView.text as NSString).replacingCharacters(in: range, with: text).count
        if textView == nameTextView {
            return numberOfChars < 21
        } else if textView == bioTextView {
            return numberOfChars < 61
        }
        return false
    }
}
