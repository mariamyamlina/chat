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
    var delegate: DataManagerDelegate?
    
    static var nameDidChange = false
    static var bioDidChange = false
    static var imageDidChange = false
    
    static var gcdButtonTapped = false
    static var operationButtonTapped = false
    
    static var name: String? = nil
    static var bio: String? = nil
    static var image: UIImage? = nil
    
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
            nameTextView.becomeFirstResponder()
            bioTextView.becomeFirstResponder()
            
            nameTextView.isEditable = true
            bioTextView.isEditable = true
            editPhotoButton.isEnabled = true
            
            nameTextView.layer.borderWidth = 1.0
            nameTextView.layer.borderColor = Colors.tableViewLightSeparatorColor.cgColor
            
            bioTextView.layer.borderWidth = 1.0
            bioTextView.layer.borderColor = Colors.tableViewLightSeparatorColor.cgColor
        } else {
            setupEditProfileButtonView(title: "Edit Profile", color: .systemBlue)
            nameTextView.resignFirstResponder()
            bioTextView.resignFirstResponder()
            
            nameTextView.isEditable = false
            bioTextView.isEditable = false
            editPhotoButton.isEnabled = false
            
            nameTextView.layer.borderWidth = 0.0
            bioTextView.layer.borderWidth = 0.0
            
            gcdSaveButton.isEnabled = false
            operationSaveButton.isEnabled = false
        }
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /*
         Loger.printButtonLog(GCDSaveButton, #function)
         
         Почему возникает ошибка "Unexpectedly found nil while implicitly unwrapping an Optional value".
         View Controller все еще находится в состоянии Unloaded:
         объект view не создан, IBOutlet и IBAction не назначены.
         Соответственно, переменная saveButton на момент вызова init имеет значение nil, поэтому при косвенном извлечении опционала вылетает error.
         Метод loadView, который срабатывает после init, загружает интерфейсный файл, создает все view, кнопки и прочие элементы в нем, а также назначает все связи IBOutlet и IBAction.
         Завершение настройки происходит в методе viewDidLoad.
        */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Loger.printButtonLog(gcdSaveButton, #function)

        // Do any additional setup after loading the view.
        nameTextView.delegate = self
        bioTextView.delegate = self
        
        setupViews()
        setupNavigationBar()
        setupButtonsConstraints()
        addKeyboardNotifications()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        var viewHeight = view.bounds.height - (navigationController?.navigationBar.bounds.height ?? view.bounds.height - 56) - 70
        if #available(iOS 13.0, *) {
        } else {
            viewHeight = viewHeight - 20
        }
        bioTextViewHeightConstraint.constant = viewHeight - 385
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Loger.printButtonLog(gcdSaveButton, #function)
        /*
        Почему значения frame отличаются при определенной конфигурации девайсов storyboard/simulator.
        Так как в .storyboard выбран iPhone SE 2, а запускается проект на iPhone 11/iPhone 11 Pro: они имеют разный размер экранов.
        В методе viewDidLoad объект view уже создан, но еще не добавлен в иерархию.
        Настройка элементов происходит в методе viewWillAppear.
        В состоянии Appearing происходит анимация View Controller в процессе появления.
        После срабатывает viewDidAppear, при этом view уже имеет свой окончательный внешний вид.
        */
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
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification

            gcdSaveButtonBottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height - 20 : -20
            operationSaveButtonBottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height - 20 : -20
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if isKeyboardShowing {
                    let bottomOffset = CGPoint(x: 0, y: keyboardFrame.height)
                    if(bottomOffset.y > 0) {
                        self.scrollView.setContentOffset(bottomOffset, animated: true)
                    }
                }
            })
        }
    }
    
    
    // MARK: - Theme
    
    fileprivate func applyTheme() {
        let currentTheme = Theme.current.themeOptions
        view.backgroundColor = currentTheme.backgroundColor
        scrollViewContentView.backgroundColor = currentTheme.backgroundColor
        
        activityIndicator.color = currentTheme.inputAndCommonTextColor
        
        gcdSaveButton.backgroundColor = currentTheme.saveButtonColor
        operationSaveButton.backgroundColor = currentTheme.saveButtonColor
        editProfileButton.backgroundColor = currentTheme.saveButtonColor
        
        if #available(iOS 13.0, *) {
        } else {
            nameTextView.keyboardAppearance = currentTheme.keyboardAppearance
            bioTextView.keyboardAppearance = currentTheme.keyboardAppearance
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
    
    func loadCompletion(_ succeed: Bool) -> Void {
        if succeed {
            activityIndicator.stopAnimating()
            configureAlert("Data has been successfully saved", nil, false)
            editProfileButton.isEnabled = true
            setupEditProfileButtonView(title: "Edit Profile", color: .systemBlue)
        } else {
            configureAlert("Error", "Failed to save data", true)
        }
    }
    
    func uploadCompletion(_ mustOverwriteName: Bool, _ mustOverwriteBio: Bool, _ mustOverwriteImage: Bool) -> Void {
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
                if GCDDataManager.profileViewController == nil {
                        GCDDataManager.profileViewController = self
                }
                if action == .read {
                    gcdDataManager.readFromFile(completion: uploadCompletion(_:_:_:))
                    uploadCompletion(true, true, true)
                } else {
                    gcdDataManager.writeToFile(completion: loadCompletion(_:))
                }
            }
        case .operation:
            if let operationDataManager: OperationDataManager = DataManager.returnDataManager(of: dataManager) {
                if OperationDataManager.profileViewController == nil {
                    OperationDataManager.profileViewController = self
                }
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

//        You can choose here how to read data by the inizialization
        referToFile(action: .read, dataManager: .gcd)
//        referToFile(action: .read, dataManager: .operation)

        setupTextViews()
        setupButtonViews()
    }
    
    private func setupButtonViews() {
        setupEditProfileButtonView(title: "Edit Profile", color: .systemBlue)
        editProfileButton.layer.cornerRadius = 14
        editProfileButton.clipsToBounds = true
        
        gcdSaveButton.layer.cornerRadius = 14
        gcdSaveButton.clipsToBounds = true
        
        operationSaveButton.layer.cornerRadius = 14
        operationSaveButton.clipsToBounds = true
        
        gcdSaveButton.isEnabled = false
        operationSaveButton.isEnabled = false
    }
    
    private func setupButtonsConstraints() {
        view.addSubview(gcdSaveButton)
        view.addSubview(gcdSaveButton)

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

        nameTextView.autocorrectionType = .no
        bioTextView.autocorrectionType = .no
        
        nameTextView.autocapitalizationType = .words
        bioTextView.autocapitalizationType = .sentences
        
        nameTextView.attributedText = NSAttributedString(string: ProfileViewController.name ?? "Marina Dudarenko",
                                                          attributes: [NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Bold", size: 24) as Any, NSAttributedString.Key.foregroundColor: currentTheme.inputAndCommonTextColor])
        bioTextView.attributedText = NSAttributedString(string: ProfileViewController.bio ?? "UX/UI designer, web-designer" + "\n" + "Moscow, Russia",
        attributes: [NSAttributedString.Key.font : UIFont(name: "SFProText-Regular", size: 16) as Any, NSAttributedString.Key.foregroundColor: currentTheme.inputAndCommonTextColor])
        
        nameTextView.isScrollEnabled = false
        
        nameTextView.textAlignment = .center
        bioTextView.textAlignment = .left
        
        nameTextView.backgroundColor = view.backgroundColor
        bioTextView.backgroundColor = view.backgroundColor
        
        nameTextView.isEditable = false
        bioTextView.isEditable = false
        editPhotoButton.isEnabled = false
        
        nameTextView.layer.cornerRadius = 14
        nameTextView.clipsToBounds = true
        
        bioTextView.layer.cornerRadius = 14
        bioTextView.clipsToBounds = true
    }
    
    private func setupEditProfileButtonView(title: String, color: UIColor) {
        editProfileButton.setTitle(title, for: .normal)
        editProfileButton.setTitleColor(color, for: .normal)
        editProfileButton.setTitleColor(.lightGray, for: .disabled)
    }
    
    private func enableSomeViews() {
        editProfileButton.isEnabled = false
        activityIndicator.startAnimating()
        
        nameTextView.layer.borderWidth = 0
        bioTextView.layer.borderWidth = 0
        
        gcdSaveButton.isEnabled = false
        operationSaveButton.isEnabled = false

        nameTextView.isEditable = false
        bioTextView.isEditable = false
        editPhotoButton.isEnabled = false
    }
    
    
    // MARK: - Navigation
    
    private func setupNavigationBar() {
        let leftViewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 115, height: 22))
        leftViewLabel.text = "My Profile"
        
        if #available(iOS 13.0, *) {
        } else {
            let currentTheme = Theme.current.themeOptions
            
            navigationController?.navigationBar.barStyle = currentTheme.barStyle
            leftViewLabel.textColor = currentTheme.inputAndCommonTextColor
        }

        leftViewLabel.font = UIFont(name: "SFProDisplay-Bold", size: 26)
        let leftItem = UIBarButtonItem(customView: leftViewLabel)
        navigationItem.leftBarButtonItem = leftItem
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeProfileViewController))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "SFProText-Semibold", size: 17) as Any], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "SFProText-Semibold", size: 17) as Any], for: .highlighted)
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

        let galeryAction = UIAlertAction(title: "Choose from gallery", style: .default) { (action) in
            self.presentImagePicker(of: .photoLibrary)
        }
        
        let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default) { (action) in
            self.presentImagePicker(of: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }

        for action in [galeryAction, takePhotoAction, cancelAction] {
            alertController.addAction(action)
        }

        if #available(iOS 13.0, *) {
        } else {
            if let subview = alertController.view.subviews.first?.subviews.first?.subviews.first {
                let currentTheme = Theme.current.themeOptions
                subview.backgroundColor = currentTheme.alertColor
            }
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func configureAlert(_ title: String, _ message: String?, _ twoActions: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: {(alert: UIAlertAction) in
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
            let repeatAction = UIAlertAction(title: "Repeat", style: .default, handler: {(alert: UIAlertAction) in
                if ProfileViewController.gcdButtonTapped {
                    self.referToFile(action: .write, dataManager: .gcd)
                } else if ProfileViewController.operationButtonTapped {
                    self.referToFile(action: .write, dataManager: .operation)
                }
            })
            alertController.addAction(repeatAction)
        }
        
        if #available(iOS 13.0, *) {
        } else {
            if let subview = alertController.view.subviews.first?.subviews.first?.subviews.first {
                let currentTheme = Theme.current.themeOptions
                subview.backgroundColor = currentTheme.alertColor
            }
        }

        self.present(alertController, animated: true, completion: nil)
    }
}

//https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints
extension UIAlertController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        pruneNegativeWidthConstraints()
    }
    
    func pruneNegativeWidthConstraints() {
        for subview in self.view.subviews {
            for constraint in subview.constraints where constraint.debugDescription.contains("width == - 16") {
                subview.removeConstraint(constraint)
            }
        }
    }
}


// MARK: - ScrollViewDelegate

extension ProfileViewController: UIScrollViewDelegate {}


// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        guard let compressData = chosenImage?.jpegData(compressionQuality: 0.5) else { return }
        let compressedImage = UIImage(data: compressData)
        
        profileImageView.profileImage.image = chosenImage
        profileImageView.lettersLabel.isHidden = true
        
        imagePicker.dismiss(animated: true, completion: nil)

        gcdSaveButton.isEnabled = true
        operationSaveButton.isEnabled = true
        
        ProfileViewController.imageDidChange = true
        ProfileViewController.image = compressedImage
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
        gcdSaveButton.isEnabled = true
        operationSaveButton.isEnabled = true
        
        switch textView {
        case nameTextView:
            ProfileViewController.nameDidChange = true
        case bioTextView:
            ProfileViewController.bioDidChange = true
        default:
            break
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView {
        case nameTextView:
            ProfileViewController.name = textView.text
        case bioTextView:
            ProfileViewController.bio = textView.text
        default:
            break
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == nameTextView {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            return numberOfChars < 21
        } else if textView == bioTextView {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            return numberOfChars < 61
        }
        return false
    }
}

