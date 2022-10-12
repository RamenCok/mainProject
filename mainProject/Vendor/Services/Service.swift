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
    func getBrandList(_ completion: @escaping ([Brands],Error?)-> Void)
    func getBrandImage(path: String, completion: @escaping (UIImage)-> Void)
}

struct MockService {
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
    
}

// Tes firebase asli disini
struct Service: Servicing {
    
    func getBrandList(_ completion: @escaping ([Brands],Error?)-> Void) {
        var array = [Brands]()
        Firestore.firestore().collection("brand").getDocuments { snapshot, error in
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents {
                let data = document.data()
                let dict = Brands(dictionary: data)
                array.append(dict)
            }
            completion(array, error)
        }
    }
    
    func getBrandImage(path: String, completion: @escaping (UIImage)-> Void) {
        let ref = Storage.storage().reference(withPath: path)
        ref.getData(maxSize: (3 * 1024 * 1024)) { data, error in
            if let _error = error {
                print(_error)
            } else {
                if let _data = data {
                    let image: UIImage! = UIImage(data: _data)
                    completion(image)
                }
            }
        }
    }
}

