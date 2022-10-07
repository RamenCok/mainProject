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

//struct UserBodyMeasurement {
//    var bust: Int
//    var waist: Int
//    var height: Int
//    var hips: Int
//    var arm: Int
//    var thigh: Int
//    var shoulder: Int
//    var sleeve: Int
//    
//    init(dictionary: [String: Int]) {
//        self.bust = dictionary["bust"] ?? 0
//        self.waist = dictionary["waist"] ?? 0
//        self.height = dictionary["height"] ?? 0
//        self.hips = dictionary["hips"] ?? 0
//        self.arm = dictionary["arm"] ?? 0
//        self.thigh = dictionary["thigh"] ?? 0
//        self.shoulder = dictionary["shoulder"] ?? 0
//        self.sleeve = dictionary["sleeve"] ?? 0
//    }
//}

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
