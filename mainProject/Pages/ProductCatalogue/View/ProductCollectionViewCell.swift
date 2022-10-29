//
//  ProductCollectionViewCell.swift
//  mainProject
//
//  Created by Bryan Kenneth on 09/10/22.
//

import UIKit
import SnapKit
import SDWebImage

class ProductCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProductCollectionViewCell"
    
    var productName: String!
    var productImage: String!
    var colorsAsset: [String]!
    
    //MARK: - Cell animation when touched
    var disabledHighlightedAnimation = false
    
    // MARK: - Cell animation when touched
    func freezeAnimations() {
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }
    
    func unfreezeAnimations() {
        disabledHighlightedAnimation = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        if disabledHighlightedAnimation {
            return
        }
        if isHighlighted {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: [.allowUserInteraction], animations: {
                self.transform = .init(scaleX: 0.96, y: 0.96)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: [.allowUserInteraction], animations: {
                self.transform = .identity
            }, completion: completion)
        }
    }
    
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
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configure() {
        contentView.clipsToBounds = false
        
        productLabel.text = productName
        guard let url = URL(string: productImage) else { return }
        productImageView.sd_setImage(with: url)

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
        
        let colorArray = ProductColorView(colorarray: colorsAsset)
        contentView.addSubview(colorArray)
        colorArray.snp.makeConstraints { make in
            make.top.equalTo(productLabel.snp.bottom).offset(9)
            make.leading.equalTo(contentView.snp.leading).offset(15)
        }
        
        contentView.layer.cornerRadius = 20
        
        contentView.backgroundColor = .whiteColor
        contentView.layer.borderColor = UIColor.lightGray3.cgColor
        contentView.layer.borderWidth = 1
        
        contentView.layer.shadowColor = UIColor.lightGray3.cgColor
        contentView.layer.shadowOpacity = 0.15
        contentView.layer.shadowOffset = CGSize.zero
        contentView.layer.shadowRadius = 25
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        productImageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.width)
        productLabel.frame = CGRect(x: 0, y: contentView.frame.size.width + 10, width: contentView.frame.size.width-10, height: 60)
    }
}
