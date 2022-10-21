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
    
    let service: BrandServicing
    
    init(service: BrandServicing) {
        self.service = service
    }
    
    let brandList = PassthroughSubject<[Brands], Never>()
    let userProfile = PassthroughSubject<String, Never>()

    func fetchBrandList() {
        service.getBrandList { list, _ in
            self.brandList.send(list)
        }
    }
    
    func fetchUserProfile() {
        service.getUser { user, error in
            self.userProfile.send(user.userProfilePicture)
        }
    }
}
