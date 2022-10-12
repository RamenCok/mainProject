//
//  BrandCatalogueViewModel.swift
//  mainProject
//
//  Created by Bryan Kenneth on 03/10/22.
//

import Foundation
import UIKit
import Combine

class BrandCatalogueViewModel: ObservableObject {
    
    let service: Servicing
    
    init(service: Servicing) {
        self.service = service
    }
    
    let brandList = PassthroughSubject<[Brands], Never>()

    func fetchBrandList() {
        service.getBrandList { list, _ in
            self.brandList.send(list)
        }
    }
}
