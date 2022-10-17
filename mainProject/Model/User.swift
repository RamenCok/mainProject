//
//  User.swift
//  mainProject
//
//  Created by Bryan Kenneth on 12/10/22.
//

import Foundation

struct User {
    
    var userName: String
    var userGender: String
    var userProfilePicture: String
    var userBodyMeasurement: [String: Int]
    
    init(dictionary: [String: Any]) {
        self.userName = dictionary["name"] as? String ?? ""
        self.userGender = dictionary["gender"] as? String ?? ""
        self.userProfilePicture = dictionary["userProfilePicture"] as? String ?? ""
        self.userBodyMeasurement = dictionary["userBodyMeasurement"] as? [String: Int] ?? [:]
    }
}
