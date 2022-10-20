//
//  Products.swift
//  mainProject
//
//  Created by Kevin Harijanto on 10/10/22.
//

import Foundation

struct Product {
    
    var productName: String
    var productDesc: String
    var productImage: String
    var colorsAsset: [[String: Any]]
    var productSizeChart: [ProductSizeChart]
    
    init(dictionary: [String: Any]) {
        self.productName = dictionary["productName"] as? String ?? ""
        self.productDesc = dictionary["productDesc"] as? String ?? ""
        self.productImage = dictionary["productImage"] as? String ?? ""
        self.colorsAsset = dictionary["colorsAsset"] as? [[String: Any]] ?? [[:]]
        self.productSizeChart = dictionary["productSizeChart"] as? [ProductSizeChart] ?? [ProductSizeChart(sizeName: 10, sizeDimension: [:])]
    }
}

struct ProductSizeChart {
    
    var sizeName: Int
    var sizeDimension: [String: Int]
}
