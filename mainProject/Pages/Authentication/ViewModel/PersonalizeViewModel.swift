//
//  PersonalizeViewModel.swift
//  mainProject
//
//  Created by Bryan Kenneth on 12/10/22.
//

import Foundation
import Combine

class PersonalizeViewModel: ObservableObject{
    let service: UserServicing
    
    init(service: UserServicing) {
        self.service = service
    }
    
    let userInfo = PassthroughSubject<User, Never>()
    
    func fetchUser(){
        service.getUserInfo { user in
            self.userInfo.send(user)
        }
    }
    
    func saveData(updatedData: Dictionary<String, Any>, completion: @escaping () -> Void){
        service.updateData(updatedData, completion: completion)
    }
    
}
