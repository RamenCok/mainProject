//
//  UserService.swift
//  mainProject
//
//  Created by Bryan Kenneth on 12/10/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol UserServicing {
    func getUserInfo(_ completion: @escaping (User) -> Void)
    func updateData(_ updateData: Dictionary<String, Any>, completion: @escaping () -> Void)
}

struct UserService: UserServicing {
    func updateData(_ updateData: Dictionary<String, Any>, completion: @escaping () -> Void) {
        FR_REF_USER.document(Auth.auth().currentUser!.uid).updateData(updateData) { err in
            if let err = err {
                print(err)
            } else {
                completion()
            }
        }
    }
    
    func getUserInfo(_ completion: @escaping (User) -> Void) {
        FR_REF_USER.document(Auth.auth().currentUser!.uid).getDocument { document, error in
            if let document = document {
                let user = User(credential: document.data()!)
                completion(user)
            }
            
        }
    }
}
