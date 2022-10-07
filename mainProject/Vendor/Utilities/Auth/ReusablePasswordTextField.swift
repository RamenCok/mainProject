//
//  ReusablePasswordTextField.swift
//  mainProject
//
//  Created by Bryan Kenneth on 06/10/22.
//

import UIKit
import SnapKit

class ReusablePasswordTextField: ReusableTextFieldAuth {
    private var showPassword = false
    public private(set) var placeholderss: String
    public private(set) var selector: Selector
    public private(set) var target: Any
    public let button = UIButton(type: .custom)
  
    
    init(placeholderss: String, selector: Selector, target: Any) {
        self.placeholderss = placeholderss
        self.selector = selector
        self.target = target
        super.init(placeholders: placeholderss)
        configurePassword()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePassword(){
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .greyColor
        button.addTarget(target, action: selector, for: .touchUpInside)
        
        self.addSubview(button)
        self.isSecureTextEntry = true
        
        button.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-15)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    func updateImage(newImage: String){
        button.setImage(UIImage(systemName: newImage), for: .normal)
    }

    
    
}
