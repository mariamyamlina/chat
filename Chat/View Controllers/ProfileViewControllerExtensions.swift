//
//  ProfileViewControllerExtensions.swift
//  Chat
//
//  Created by Maria Myamlina on 02.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

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
