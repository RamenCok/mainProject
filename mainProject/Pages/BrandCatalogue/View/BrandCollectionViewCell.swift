//
//  BrandCollectionViewCell.swift
//  mainProject
//
//  Created by Bryan Kenneth on 03/10/22.
//

import UIKit
import SnapKit
import SDWebImage

class BrandCollectionViewCell: UICollectionViewCell {
    static let identifier = "BrandCollectionViewCell"
    var brandName: String!
    var brandImage: String!
    
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
    
    // MARK: - cell init
    private lazy var brandImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        imageView.backgroundColor = .white
        
        imageView.layer.shadowColor = UIColor.tesColor.cgColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowOffset = CGSize.zero
        imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 30).cgPath
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configure the cell
    func configure() {
        guard let brandImageUrl = URL(string: brandImage) else { return }
        brandImageView.sd_setImage(with: brandImageUrl)
        contentView.addSubview(brandImageView)
        
        brandLabel.text = brandName!
        contentView.addSubview(brandLabel)
        
        contentView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        brandLabel.frame = CGRect(x: 0, y: contentView.frame.size.width + 10, width: contentView.frame.size.width-10, height: 20)
        brandImageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.width)
    }
}
