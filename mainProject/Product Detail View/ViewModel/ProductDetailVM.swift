//
//  ProductDetailVM.swift
//  mainProject
//
//  Created by Kevin Harijanto on 03/10/22.
//

import Foundation

class ProductDetailVM {
    
    let service: Servicing
    
    init(service: Servicing) {
        self.service = service
    }
    
    var updatedData: ((Product)-> Void)?
    
    func fetchData() {
        service.getData { [weak self] data in
            self?.updatedData?(data)
        }
    }
}
