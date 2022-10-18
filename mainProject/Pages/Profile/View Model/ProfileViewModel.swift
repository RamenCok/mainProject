//
//  ProfileViewModel.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 12/10/22.
//

import Foundation
import Combine
import UIKit

class ProfileViewModel: ObservableObject {
    
    let service: ProfileServices
    let user = PassthroughSubject<User, Never>()
    
    init(service: ProfileServices) {
        self.service = service
    }
    
    func getUser() {
        service.getUser { user, error in
            print("DEBUG: Hallo")
            self.user.send(user)
        }
    }
    
    func updateUser(name: String, gender: String, imageData: UIImage) {
        service.updateUser(name: name, gender: gender, imageData: imageData) { error in
            print("DEBUG: \(error)")
        }
    }
}
