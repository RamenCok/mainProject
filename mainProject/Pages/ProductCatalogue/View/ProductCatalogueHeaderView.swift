//
//  ProductCatalogueHeaderView.swift
//  mainProject
//
//  Created by Kevin Harijanto on 13/10/22.
//

import UIKit

class ProductCatalogueHeaderView: UICollectionReusableView {
    
    static let identifier = "ProductCatalogueHeaderView"
    
    var numberOfItem: Int!
    
    private lazy var label: UILabel = {
        let label = ReusableLabel(style: .caption, textString: "")
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()
    
    public func configure() {
        if numberOfItem != 1 {
            label.text = "\(numberOfItem!) Product(s)"
        } else {
            label.text = "\(numberOfItem!) Product"
        }
        
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}
