//
//  ProfileViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 17.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ProfileViewController: LogViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker: UIImagePickerController!

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBAction func editButtonTapped(_ sender: UIButton) {
        configureActionSheet()
    }
    @IBOutlet weak var profileImageView: ProfileImageView!
    
    static var letters: String = {
        let lettersArray = ProfileViewController.name.components(separatedBy: .whitespaces)
        if lettersArray.count == 2 {
            let letters = [String(lettersArray[0].first ?? "M"), String(lettersArray[1].first ?? "D")]
            return letters[0] + letters[1]
        } else {
            return "MD"
        }
    }()
    
    static var name: String = {
        return "Marina Dudarenko"
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /*
         Loger.printButtonLog(saveButton, #function)
         
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
        
        Loger.printButtonLog(saveButton, #function)

        // Do any additional setup after loading the view.
        setupViews()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Loger.printButtonLog(saveButton, #function)
        /*
        Почему значения frame отличаются при определенной конфигурации девайсов storyboard/simulator.
        Так как в .storyboard выбран iPhone SE 2, а запускается проект на iPhone 11/iPhone 11 Pro: они имеют разный размер экранов.
        В методе viewDidLoad объект view уже создан, но еще не добавлен в иерархию.
        Настройка элементов происходит в методе viewWillAppear.
        В состоянии Appearing происходит анимация View Controller в процессе появления.
        После срабатывает viewDidAppear, при этом view уже имеет свой окончательный внешний вид.
        */
    }
    
    
    // MARK: - Views
    
    func setupViews() {
        let currentTheme = Theme.current.themeOptions
        
        view.backgroundColor = currentTheme.backgroundColor
        nameLabel.textColor = currentTheme.inputAndCommonTextColor
        bioLabel.textColor = currentTheme.inputAndCommonTextColor

        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        profileImageView.clipsToBounds = true
        
        nameLabel.text = ProfileViewController.name
        bioLabel.text = "UX/UI designer, web-designer" + "\n" + "Moscow, Russia"

        if profileImageView.profileImage.image != nil {
            profileImageView.lettersLabel.isHidden = true
        }
        
        saveButton.layer.cornerRadius = 14
        saveButton.clipsToBounds = true
        saveButton.backgroundColor = currentTheme.saveButtonColor
    }
    
    
    // MARK: - Navigation
    
    func setupNavigationBar() {
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
    
    @objc func closeProfileViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - ImagePicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        profileImageView.profileImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        profileImageView.lettersLabel.isHidden = true
    }
    
    
    // MARK: - Alert
    
    func configureActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.pruneNegativeWidthConstraints()
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true

        let galeryAction = UIAlertAction(title: "Choose from gallery", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                self.configureAlert(title: "Can't open gallery")
            }
        }
        
        let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                self.configureAlert(title: "Can't take a photo")
            }
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
    
    func configureAlert(title: String) {
        let alertController = UIAlertController(title: title, message: "Check your device and try later", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
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
