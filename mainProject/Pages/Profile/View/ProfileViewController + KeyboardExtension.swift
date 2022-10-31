//
//  ProfileViewController + KeyboardExtensions.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 05/10/22.
//

import UIKit

extension ProfileViewController {
    
    override func setEditing(_ editing: Bool, animated: Bool) {

        // overriding this method means we can attach custom functions to the button
        super.setEditing(editing, animated: animated)

        // attaching custom actions here
        if editing {
            UIView.animate(withDuration: 0.2) {
                self.editProfileImageButton.alpha = 1
                
                self.genderButton.alpha = 1
                self.genderLabel.backgroundColor = .textFieldBG
                self.genderLabel.textColor = .black
                
                self.nameTF.isEnabled = true
                self.nameTF.backgroundColor = .textFieldBG
                self.nameTF.textColor = .black
            }
            
        } else {
            UIView.animate(withDuration: 0.2) {
                self.editProfileImageButton.alpha = 0
                
                self.genderButton.alpha = 0
                self.genderLabel.backgroundColor = .clear
                self.genderLabel.textColor = .blackTexts
                
                self.nameTF.isEnabled = false
                self.nameTF.backgroundColor = .clear
                self.nameTF.textColor = .blackTexts
                
                if self.user.userGender != self.genderLabel.text {
                    self.changeGenderAlertConfirmation()
                } else {
                    self.sendUpdates()
                }
            }
        }
    }
    
    func sendUpdates() {
        
        self.vm.updateUser(
            name: self.nameTF.text ?? "",
            gender: self.genderLabel.text ?? "",
            imageData: self.profileImage.image ?? UIImage()
        )
        
        self.user.userName = self.nameTF.text!
        self.user.userGender = self.genderLabel.text!
        
        self.configureUI()
    }

    func changeGenderAlertConfirmation() {
        
        let alertController = UIAlertController(title: "Change Gender", message: "Changing your gender will reset all of your body measurement", preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: "I'm sure!", style: .default) { action in
            
            self.vm.service.resetBodyMeasurementToZero()
            self.user.userBodyMeasurement = ["Chest": 0, "Height": 0, "Waist": 0]
            
            self.sendUpdates()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            self.nameTF.text = self.user.userName
            self.genderLabel.text = self.user.userGender
            self.profileImage.sd_setImage(with: URL(string: self.user.userProfilePicture))
            self.dismiss(animated: true)
        }
        
        alertController.addAction(firstAction)
        alertController.addAction(cancelAction)
        
        alertController.view.tintColor = .primaryColor
        
        self.present(alertController, animated: true)
    }
}
