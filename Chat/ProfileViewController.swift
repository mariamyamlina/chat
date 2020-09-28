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

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lettersLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBAction func editButtonTapped(_ sender: UIButton) {
        configureActionSheet()
    }
    
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
    
    func setupViews() {
        profileImage.layer.cornerRadius = profileImage.bounds.size.width / 2
        profileImage.contentMode = .scaleAspectFill
        
        saveButton.layer.cornerRadius = 14
        saveButton.clipsToBounds = true
        
        nameLabel.text = "Marina Dudarenko"
        bioLabel.text = "UX/UI designer, web-designer" + "\n" + "Moscow, Russia"
        
        let lettersArray = nameLabel.text?.components(separatedBy: .whitespaces)
        if let unwrappedArray = lettersArray, unwrappedArray.count == 2, profileImage.image == nil {
            let letters = [String(unwrappedArray[0].first ?? "M"), String(unwrappedArray[1].first ?? "D")]
            lettersLabel.text = letters[0] + letters[1]
        } else {
            lettersLabel.isHidden = true
        }
    }
    
    func setupNavigationBar() {
        let leftViewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 115, height: 22))
        leftViewLabel.text = "My Profile"
        leftViewLabel.textColor = .black
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - ImagePicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        profileImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        lettersLabel.isHidden = true
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        for action in [galeryAction, takePhotoAction, cancelAction] {
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func configureAlert(title: String) {
        let alertController = UIAlertController(title: title, message: "Check your device and try later", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
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
