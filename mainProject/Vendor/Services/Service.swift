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
    func get3DAsset(path: String) async
}

// Tes firebase asli disini
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
    
    func get3DAsset(path: String) async {
        do {
            let storage = Storage.storage().reference()
            let modelPath = storage.child("Product3DAsset/\(path)")
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let tempDirectory = URL.init(fileURLWithPath: paths, isDirectory: true)
            let targetUrl = tempDirectory.appendingPathComponent("\(path)")
            
            modelPath.write(toFile: targetUrl) { (url, error) in
                if error != nil {
                    print("ERROR: \(error!)")
                }else{
                    print("DEBUG: modelPath.write OKAY")
                }
            }
        }
    }
}

