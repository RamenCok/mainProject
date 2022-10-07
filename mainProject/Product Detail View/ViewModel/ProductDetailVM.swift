//
//  ProductDetailVM.swift
//  mainProject
//
//  Created by Kevin Harijanto on 03/10/22.
//

import Foundation
import Combine

class ProductDetailVM: ObservableObject {
    
    let service: Servicing
    
    init(service: Servicing) {
        self.service = service
    }
    
    let updatedData = PassthroughSubject<Product, Never>()
    
    func fetchData() {
        service.getData { [weak self] data in
            self?.updatedData.send(data)
        }
    }
}
