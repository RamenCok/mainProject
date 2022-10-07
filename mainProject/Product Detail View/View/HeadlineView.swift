//
//  HeadlineView.swift
//  mainProject
//
//  Created by Kevin Harijanto on 05/10/22.
//

import Foundation
import UIKit

class HeadlineView: UIView {
    // MARK: - Properties
    
    private var brandName: String
    private var productName: String
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up")?.scalePreservingAspectRatio(targetSize: CGSize(width: 27, height: 27)), for: .normal)
        button.addTarget(self, action: #selector(handleShareButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    required init(brandName: String, productName: String) {
        self.brandName = brandName
        self.productName = productName
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleShareButton() {
        print("Share")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        let productHeadline = productHeadline(brandName: brandName, productName: productName)
        addSubview(productHeadline)
        productHeadline.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.height.equalTo(self)
        }
    }
    
    private func productHeadline(brandName: String, productName: String)->UIView {
        let brandName = ReusableLabel(style: .productDetailBrand, textString: "\(brandName)")
        brandName.textColor = UIColor("949494")
        
        let productName = ReusableLabel(style: .heading_2, textString: "\(productName)")
        productName.numberOfLines = 2
        
        let productInfo = UIStackView(arrangedSubviews: [brandName, productName])
        productInfo.axis = .vertical
        productInfo.alignment = .leading
        productInfo.spacing = 3
        
        let productHeadline = UIStackView(arrangedSubviews: [productInfo, shareButton])
        productHeadline.axis = .horizontal
        productHeadline.alignment = .center
        productHeadline.distribution = .fill
        productHeadline.spacing = 10
        return productHeadline
    }
}
