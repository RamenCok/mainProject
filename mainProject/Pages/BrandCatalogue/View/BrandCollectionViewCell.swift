//
//  BrandCollectionViewCell.swift
//  mainProject
//
//  Created by Bryan Kenneth on 03/10/22.
//

import UIKit
import SnapKit

class BrandCollectionViewCell: UICollectionViewCell {
    static let identifier = "BrandCollectionViewCell"
    
    private lazy var brandImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sample-logo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        imageView.backgroundColor = .white
        
        imageView.layer.shadowColor = UIColor.tesColor.cgColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowOffset = CGSize.zero
//        imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 10).cgPath
        imageView.layer.shadowRadius = 5
        
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = UIColor.tesColor.cgColor
        return imageView
    }()
    
    private lazy var brandLabel: UILabel = {
        let label = ReusableLabel(style: .bodyText, textString: "H&M")
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(brandImageView)
        contentView.addSubview(brandLabel)
        contentView.clipsToBounds = true
        
        
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        brandLabel.frame = CGRect(x: 0, y: contentView.frame.size.width + 10, width: contentView.frame.size.width-10, height: 20)
        brandImageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.width)
//        contentView.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(5)
//            make.trailing.equalToSuperview().offset(5)
//        }
        
    }
}
