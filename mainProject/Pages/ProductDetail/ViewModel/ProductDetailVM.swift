//
//  ProductDetailVM.swift
//  mainProject
//
//  Created by Kevin Harijanto on 03/10/22.
//

import Foundation
import Combine

class ProductDetailVM: ObservableObject {
    
    let service: ProductServicing

    init(service: ProductServicing) {
        self.service = service
    }

    let path = PassthroughSubject<String, Never>()

    func fetch3DAsset(path: String) async {
        await service.get3DAsset(path: path)
    }
}
