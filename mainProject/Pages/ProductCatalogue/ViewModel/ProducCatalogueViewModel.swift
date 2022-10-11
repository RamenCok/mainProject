//
//  ProducCatalogueViewModel.swift
//  mainProject
//
//  Created by Bryan Kenneth on 09/10/22.
//

import Foundation

import UIKit

class ProductCatalogueViewModel: ObservableObject {
    
    var productList = [
        Brands(name: "H&M", logo: "sample-logo"),
        Brands(name: "Lacoste", logo: "sample-logo"),
        Brands(name: "Tommy Hilfiger", logo: "sample-logo"),
        Brands(name: "Under Armour", logo: "sample-logo"),
    ]
    
    
}

