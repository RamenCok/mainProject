//
//  Service.swift
//  mainProject
//
//  Created by Kevin Harijanto on 10/10/22.
//

import Foundation
import Firebase
import FirebaseStorage

protocol BrandServicing {
    func getBrandList(_ completion: @escaping ([Brands],Error?)-> Void)
}

protocol ProductServicing {
    func getProduct(ref: String, completion: @escaping (Product)-> Void)
}

protocol ProfileServices {
    func getUser(_ completion: @escaping (User, Error?) -> Void)
    func updateUser(name: String, gender: String, imageData: UIImage, completion: @escaping (Error?) -> Void)
}

struct Service: ProfileServices {
    
    let uid = AUTH_REF.currentUser?.uid
    
    func getUser(_ completion: @escaping (User, Error?) -> Void) {
        
        let document = Firestore.firestore().collection("users").document(uid!)
        
        document.getDocument { document, error in
            
            if let document = document, document.exists {
                let dictionary = document.data()
                let user = User(dictionary: dictionary ?? ["" : ""])
                completion(user, error)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func updateUser(name: String, gender: String, imageData: UIImage, completion: @escaping (Error?) -> Void) {
        
       
        let reference = Firestore.firestore().collection("users").document(uid!)
        let storage = Storage.storage().reference().child("ProfilePicture/\(uid!)")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        guard let data = imageData.jpegData(compressionQuality: 1.0) else { return }
        
        storage.putData(data, metadata: metaData) { _ in
            
            storage.downloadURL { url, error in
                
                guard let profilePictureURL = url?.absoluteString else { return }
                
                reference.updateData([
                    "name": name,
                    "gender": gender,
                    "userProfilePicture": profilePictureURL
                ])
            }
        }
    }
}

struct BrandService: BrandServicing {
    
    func getBrandList(_ completion: @escaping ([Brands],Error?)-> Void) {
        var result = [Brands]()
        Firestore.firestore().collection("brand").getDocuments { snapshot, error in
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents {
                let dict = document.data()
                let data = Brands(dictionary: dict)
                result.append(data)
            }
            completion(result, error)
        }
    }
}

struct ProductService: ProductServicing {
    
    func getProduct(ref: String, completion: @escaping (Product)-> Void) {
        let data = Firestore.firestore().collection("product").document(ref)
        data.addSnapshotListener { snapshot, error in
            let dict = snapshot?.data()
            let data = Product(dictionary: dict ?? [:])
            completion(data)
        }
    }
}
