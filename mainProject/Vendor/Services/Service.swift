//
//  Service.swift
//  mainProject
//
//  Created by Kevin Harijanto on 10/10/22.
//

import Foundation
import Firebase
import FirebaseStorage

protocol Servicing {
    
    func getBrandList(_ completion: @escaping ([Brands], Error?)-> Void)
}

protocol ProfileServices {
    
    func getUser(_ completion: @escaping (User, Error?) -> Void)
    func updateUser(name: String, gender: String, imageData: UIImage, completion: @escaping (Error?) -> Void)
    
}

//struct MockService: Servicing {
//    func getData(_ completion: @escaping (Product)-> Void) {
//        //mock implementation
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            completion(Product(filename: "AirForce",
//                               brandName: "Love, Bonito",
//                               productName: "Lela Textured A-line Dress",
//                               productDesc: "Dreamy frills to brighten up your day. Crafted from sweat-wicking textured cotton, this mini dress features an A-line silhouette, V-neckline, and flared sleves. Comes with functional side pockets and zipper on the side. \n \n Dreamy frills to brighten up your day. Crafted from sweat-wicking textured cotton, this mini dress features an A-line silhouette, V-neckline, and flared sleves. Comes with functional side pockets and zipper on the side.",
//                               colorsArray: ["7479EA", "B55DD3", "FF95BF"]))
//        }
//    }
//    
//    func getBrandList(_ completion: @escaping ([Brands])-> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            
//            getBrandImage(brandImage: "sample-logo") { image in
//                let dict = ["H&M": image, "Lacoste": image, "Tommy Hilfiger": image]
//                completion([
//                    Brands(dictionary: dict)
//                ])
//            }
//        }
//    }
//    
//    func getBrandImage(brandImage: String, completion: @escaping (UIImage)-> Void) {
//        if let image = UIImage(named: brandImage) {
//            completion(image) 
//        }
//    }
//}


struct Service: ProfileServices {
    
    let uid = "TONNJJA7N5aMZM63kZX6YhB7eSp1"
    
    func getUser(_ completion: @escaping (User, Error?) -> Void) {
        
        let document = Firestore.firestore().collection("users").document(uid)
        
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
        
        let reference = Firestore.firestore().collection("users").document(uid)
        let storage = Storage.storage().reference().child("ProfilePicture/\(uid)")
        
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
