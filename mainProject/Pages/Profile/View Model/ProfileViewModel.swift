//
//  ProfileViewModel.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 12/10/22.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    
    let service: ProfileServices
    let user = PassthroughSubject<User, Never>()
    
    init(service: ProfileServices) {
        self.service = service
    }
    
    func getUser() {
        service.getUser { user, error in
            self.user.send(user)
        }
    }
    
    func updateUser(name: String, gender: String) {
        service.updateUser(name: name, gender: gender) { error in
            print("DEBUG: \(error)")
        }
    }
}
