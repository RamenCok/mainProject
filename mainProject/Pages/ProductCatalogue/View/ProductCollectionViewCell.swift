//
//  ProductCollectionViewCell.swift
//  mainProject
//
//  Created by Bryan Kenneth on 09/10/22.
//

import UIKit
import SnapKit

class ProductCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProductCollectionViewCell"
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sample-picture")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        return imageView
    }()
    
    private lazy var productLabel: UILabel = {
        let label = ReusableLabel(style: .modalTitle, textString: "Lela Textured A-line Dress")
        label.numberOfLines = 2
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var colorArray: ProductColorView = {
       let view = ProductColorView(colorarray: ["7479EA", "B55DD3", "FF95BF"])
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = false
        
        contentView.addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.top.equalTo(contentView.snp.top).offset(25)
        }
        
        contentView.addSubview(productLabel)
        productLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(12)
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
        }
        
        contentView.addSubview(colorArray)
        colorArray.snp.makeConstraints { make in
            make.top.equalTo(productLabel.snp.bottom).offset(9)
            make.leading.equalTo(contentView.snp.leading).offset(15)
        }
        
        contentView.layer.cornerRadius = 20
        
        contentView.backgroundColor = .systemBackground
        contentView.layer.borderColor = UIColor.lightGray3.cgColor
        contentView.layer.borderWidth = 1
        
        contentView.layer.shadowColor = UIColor.lightGray3.cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowOffset = CGSize.zero
        contentView.layer.shadowRadius = 5
        
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        productImageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.width)
        productLabel.frame = CGRect(x: 0, y: contentView.frame.size.width + 10, width: contentView.frame.size.width-10, height: 60)
        colorArray.frame = CGRect(x: 0, y: contentView.frame.size.width + 70, width: 20, height: 40)
    }
}
