//
//  AuthServices.swift
//  mainProject
//
//  Created by Bryan Kenneth on 11/10/22.
//

import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore
import FirebaseCore

import GoogleSignIn

import CryptoKit
import AuthenticationServices


struct AuthServices {
    static let shared = AuthServices()
    
    func anonymousAuth(completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signInAnonymously { authResult, error in
            completion(authResult, error)
        }
    }
    
    func registerWithEmail(email: String, password: String, completionFunc: @escaping (AuthDataResult?, Error?) -> Void) {
        AUTH_REF.createUser(withEmail: email, password: password, completion: completionFunc)
    }
    
    func loginWithEmail(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        
       AUTH_REF.signIn(withEmail: email, password: password, completion: completion)
    }
    
    func resetPassword(completion: @escaping (Error?) -> Void) {
        AUTH_REF.sendPasswordReset(withEmail: (AUTH_REF.currentUser?.email)!, completion: completion)
    }
    
    func checkUserData(uid: String, completionFunc: @escaping (DocumentSnapshot?, Error?) -> Void){
        FR_REF_USER.document(uid).getDocument(completion: completionFunc)
    }
    
    func writeUserData(credentials: Dictionary<String, Any>, completionFunc: @escaping () -> Void){
        FR_REF_USER.document(credentials["uid"] as! String).setData(credentials){err in
            if let err = err {
                print(err)
            } else {
                FR_REF_USER.document(credentials["uid"] as! String).setData(["userBodyMeasurement": ["Chest": 0, "Height": 0, "Waist": 0]])
               completionFunc()
            }
        }
    }
    
    func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    @available(iOS 13, *)
    func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
        

}

