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
    func getUser(_ completion: @escaping (User, Error?) -> Void)
}

protocol ProductServicing {
    func getProduct(ref: String, completion: @escaping (Product)-> Void)
}

protocol ProfileServices {
    func getUser(_ completion: @escaping (User, Error?) -> Void)
    func updateUser(name: String, gender: String, imageData: UIImage, completion: @escaping (Error?) -> Void)
    func updateBodyMeasurement(type: String, value: Int,  completion: @escaping() -> Void)
    func resetBodyMeasurementToZero()
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
    
    func updateBodyMeasurement(type: String, value: Int,  completion: @escaping() -> Void) {
        let reference = Firestore.firestore().collection("users").document(uid!)
        reference.setData(["userBodyMeasurement": [type: value]], merge: true)
    }
    
    func resetBodyMeasurementToZero() {
        
        let reference = Firestore.firestore().collection("users").document(uid!)
        reference.setData(["userBodyMeasurement": ["Chest": 0, "Height": 0, "Waist": 0]], merge: true)
    }
}

struct BrandService: BrandServicing {
    
    let uid = AUTH_REF.currentUser?.uid
    
    func getUser(_ completion: @escaping (User, Error?) -> Void) {
        
        guard let user = AUTH_REF.currentUser else { return }
        if !user.isAnonymous {
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
        
       
    }
    
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
            var data = Product(dictionary: dict ?? [:])
            
            // MARK: REMOVE IF STATEMENT WHEN ALL PRODUCT HAS SIZE CHART!!!
            if data.productName == "Skelly Kaos Stripe Pria Wanita Evenlike" {
                
                let productSizeChartDict = snapshot?.get("productSizeChart") as! [[String: Any]]
                
                var productSizeChart: [ProductSizeChart] = []
                
                for product in productSizeChartDict {
                    let productSize = ProductSizeChart(sizeName: product["sizeName"] as! Int, sizeDimension: product["sizeDimension"] as! [String : Int])
                    productSizeChart.append(productSize)
                }
                
                data.productSizeChart = productSizeChart
            }
            print("DEBUG DICT: \(snapshot!.data())")
            
            if let productLinksDict = snapshot?.get("buyLink") {
                
                var productLinks: [ProductLink] = []
                
                for productLink in productLinksDict as! [[String: Any]] {
                    let productLink = ProductLink(siteName: productLink["siteName"] as! String, link: productLink["link"] as! String)
                    productLinks.append(productLink)
                }
                
                data.productLinks = productLinks
            }
            
           
            
            
            
            completion(data)
        }
    }
}
