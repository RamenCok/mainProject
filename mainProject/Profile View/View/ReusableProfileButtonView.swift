//
//  ReusableProfileButtonView.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 05/10/22.
//

import UIKit

class ReusableProfileButtonView: UIButton {
 
    public private(set) var logo: String
    public private(set) var buttonText: String
    public private(set) var selector: Selector
    public private(set) var target: Any
    
    init(logo: String, buttonText: String, selector: Selector, target: Any) {
        
        self.logo = logo
        self.buttonText = buttonText
        self.selector = selector
        self.target = target
        
        super.init(frame: .zero)
        configureTarget()
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTarget(){
        self.addTarget(target, action: selector, for: .touchUpInside)
    }
    
    private func configureButton() {
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 14
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 16
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.contentHorizontalAlignment = .leading
        
        self.setTitle(buttonText, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.bodyText()
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        
        self.setImage(UIImage(named: logo), for: .normal)
        self.imageView?.contentMode = .scaleAspectFill
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        self.tintColor = .black
        
        self.snp.makeConstraints { make in
            make.height.equalTo(64)
        }
    }
}
