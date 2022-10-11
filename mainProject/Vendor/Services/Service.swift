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
    func getData(_ completion: @escaping (Product)-> Void)
    func getBrandList(_ completion: @escaping ([Brands])-> Void)
    func getBrandImage(brandImage: String, completion: @escaping (UIImage)-> Void)
}

struct MockService: Servicing {
    func getData(_ completion: @escaping (Product)-> Void) {
        //mock implementation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(Product(filename: "AirForce",
                               brandName: "Love, Bonito",
                               productName: "Lela Textured A-line Dress",
                               productDesc: "Dreamy frills to brighten up your day. Crafted from sweat-wicking textured cotton, this mini dress features an A-line silhouette, V-neckline, and flared sleves. Comes with functional side pockets and zipper on the side. \n \n Dreamy frills to brighten up your day. Crafted from sweat-wicking textured cotton, this mini dress features an A-line silhouette, V-neckline, and flared sleves. Comes with functional side pockets and zipper on the side.",
                               colorsArray: ["7479EA", "B55DD3", "FF95BF"]))
        }
    }
    
    func getBrandList(_ completion: @escaping ([Brands])-> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            getBrandImage(brandImage: "sample-logo") { image in
                let dict = ["H&M": image, "Lacoste": image, "Tommy Hilfiger": image]
                completion([
                    Brands(dictionary: dict)
                ])
            }
        }
    }
    
    func getBrandImage(brandImage: String, completion: @escaping (UIImage)-> Void) {
        if let image = UIImage(named: brandImage) {
            completion(image)
        }
    }
}

// Tes firebase asli disini
struct Service {
    func getBrandList(_ completion: @escaping ([Brands],Error?)-> Void) {
        var array = [Brands]()
        Firestore.firestore().collection("brand").getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let snapshot = snapshot else {return}
                for document in snapshot.documents {
                    let data = document.data()
                    let data2 = Brands(dictionary: data)
                    array.append(data2)
                }
                print(array)
                completion(array, nil)
            }
        }
    }
    
    func getBrandImage(brandImage: String, completion: @escaping (UIImage)-> Void) {
        if let image = UIImage(named: brandImage) {
            completion(image)
        }
    }
}

