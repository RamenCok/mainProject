//
//  BodyMeasurementVM.swift
//  mainProject
//
//  Created by Kevin Harijanto on 06/10/22.
//

import Foundation
import UIKit

class BodyMeasurementVM: ObservableObject {
    
    func getdata(_ completion: @escaping (User)-> Void) {
        
        let bodymeasurement = [
            0: 20, // bust
            1: 21, // waist
            2: 22, // height
            3: 0, // hips
            4: 0, // arm
            5: 0, // thigh
            6: 0, // shoulder
            7: 0, // sleeve
            8: 0,
            9: 0,
            10: 0,
            11: 0,
        ]
        
//        DispatchQueue.main.async {
//            completion(User(userName: "Kevin",
//                            userGender: 0,
//                            userProfilePicture: "Picture Path Here",
//                            userBodyMeasurement: bodymeasurement))
//        }
    }
}
