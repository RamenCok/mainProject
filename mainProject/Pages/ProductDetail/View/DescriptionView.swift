//
//  DescriptionView.swift
//  mainProject
//
//  Created by Kevin Harijanto on 05/10/22.
//

import Foundation
import UIKit

class DescriptionView: UIView {
    
    // MARK: - Properties
    
    private var productDesc: String
    
    //MARK: - Lifecycle
    
    required init(productDesc: String) {
        self.productDesc = productDesc
        super.init(frame: .zero)
        
        backgroundColor = .clear
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers
    
    private func configureUI() {
        let productDescription = productDescription(productDesc: productDesc)
        addSubview(productDescription)
        productDescription.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.height.equalTo(self)
        }
    }
    
    private func productDescription(productDesc: String)-> UIView {
        let label = ReusableLabel(style: .bodyText, textString: "\(productDesc)")
        label.numberOfLines = 0
        label.textColor = UIColor.blackTexts
        return label
    }
}
