//
//  SetupBodyMeasurementModalVM.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 18/10/22.
//

import Foundation

class SetupBodyMeasurementModalVM: ObservableObject {
    
    let service: ProfileServices
    
    init(service: ProfileServices) {
        self.service = service
    }
    
    func updateData(type: String, value: Int) {
        service.updateBodyMeasurement(type: type, value: value) {
            print("COK")
        }
    }
}
