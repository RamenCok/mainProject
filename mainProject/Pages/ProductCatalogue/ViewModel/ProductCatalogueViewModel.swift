//
//  ProducCatalogueViewModel.swift
//  mainProject
//
//  Created by Bryan Kenneth on 09/10/22.
//

import Foundation
import UIKit
import Combine

class ProductCatalogueViewModel: ObservableObject {
    
    let service: ProductServicing
    
    init(service: ProductServicing) {
        self.service = service
    }
    
    let productList = PassthroughSubject<[Product], Never>()

    func fetchProductList(ref: [String]) {
        var result = [Product]()
        for uid in ref {
            service.getProduct(ref: uid) { product in
                result.append(product)
                if result.count == ref.count {
                    self.productList.send(result)
                }
            }
        }
    }
}

