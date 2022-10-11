//
//  AuthServices.swift
//  mainProject
//
//  Created by Bryan Kenneth on 11/10/22.
//

import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import GoogleSignIn
import FirebaseCore


struct AuthServices {
    static let shared = AuthServices()
    
    func anonymousAuth() {
        Auth.auth().signInAnonymously { authResult, error in
            print(authResult?.user.uid)
        }
    }

}
