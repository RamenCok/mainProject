//
//  BodyMeasurementVM.swift
//  mainProject
//
//  Created by Kevin Harijanto on 06/10/22.
//

import Combine
import UIKit

class BodyMeasurementVM: ObservableObject {
    
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
}
