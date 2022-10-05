//
//  ProfileViewController + ImagePickerExtensions.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 05/10/22.
//

import UIKit

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePicker(selectedSource: UIImagePickerController.SourceType) {
        
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else { return }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = selectedSource
        imagePickerController.allowsEditing = true
        imagePickerController.view.tintColor = UIColor.primaryColor
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImage.image = selectedImage
        } else {
            print("Image not found")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
