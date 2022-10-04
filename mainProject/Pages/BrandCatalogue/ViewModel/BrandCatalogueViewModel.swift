//
//  BrandCatalogueViewModel.swift
//  mainProject
//
//  Created by Bryan Kenneth on 03/10/22.
//

import Foundation
import UIKit

class BrandCatalogueViewModel: ObservableObject {
    
    var brandList = [
        Brands(name: "H&M", logo: "sample-logo"),
        Brands(name: "Lacoste", logo: "sample-logo"),
        Brands(name: "Tommy Hilfiger", logo: "sample-logo"),
        Brands(name: "Under Armour", logo: "sample-logo")
    ]
    
    
}
