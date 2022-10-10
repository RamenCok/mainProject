//
//  BodyMeasurementVM.swift
//  mainProject
//
//  Created by Kevin Harijanto on 06/10/22.
//

import Foundation
import UIKit

struct User {
    var name: String
    var gender: Int
    var profilePicture: String
    var userBodyMeasurement: [Int: Int]
}

class BodyMeasurementVM: ObservableObject {
    
    func getdata(_ completion: @escaping (User)-> Void) {
        let bodymeasurement = [
            0: 20, // bust
            1: 21, // waist
            2: 22, // height
            3: 23, // hips
            4: 24, // arm
            5: 25, // thigh
            6: 26, // shoulder
            7: 27, // sleeve
        ]
        
        DispatchQueue.main.async {
            completion(User(name: "Kevin",
                            gender: 0,
                            profilePicture: "Picture Path Here",
                            userBodyMeasurement: bodymeasurement))
        }
    }
}
