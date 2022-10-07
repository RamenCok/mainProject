//
//  ProductModel.swift
//  mainProject
//
//  Created by Kevin Harijanto on 05/10/22.
//

import Foundation

struct DependencyProvider {
    static var service: Servicing {
        return Service()
    }
    
    static var viewModel: ProductDetailVM {
        return ProductDetailVM(service: service)
    }
    
    static var viewController: ProductDetailVC {
        let vc = ProductDetailVC()
        vc.vm = viewModel
        return vc
    }
}

struct Product {
    var filename: String
    var brandName: String
    var productName: String
    var productDesc: String
    var colorsArray: [String]
}

protocol Servicing {
    func getData(_ completion: @escaping (Product)-> Void)
}

class Service: Servicing {
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
