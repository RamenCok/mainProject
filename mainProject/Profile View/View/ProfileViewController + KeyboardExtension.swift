//
//  ProfileViewController + KeyboardExtensions.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 05/10/22.
//

import UIKit

extension ProfileViewController {
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        nameTF.resignFirstResponder()
    }
    
    func configureTextFieldObservers() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tap)
    }
}
