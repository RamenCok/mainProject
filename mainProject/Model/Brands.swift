//
//  Brands.swift
//  mainProject
//
//  Created by Bryan Kenneth on 03/10/22.
//

import Foundation
import UIKit

struct Brands {
    var brandName: String
    var brandImage: String
    
    init(dictionary: [String: Any]) {
        self.brandName = dictionary["brandName"] as? String ?? ""
        self.brandImage = dictionary["brandImage"] as? String ?? ""
    }
}
