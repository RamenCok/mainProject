//
//  User.swift
//  mainProject
//
//  Created by Bryan Kenneth on 12/10/22.
//

import Foundation

class User {
    let email: String
    let gender: String
    let name: String
    let uid: String
    
    init(credential: Dictionary<String, Any>) {
        self.email = credential["email"] as! String
        self.gender = credential["gender"] as! String
        self.name = credential["name"] as! String
        self.uid = credential["uid"] as! String
    }
}
