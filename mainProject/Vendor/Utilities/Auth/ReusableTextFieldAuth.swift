//
//  ReusableTextFieldAuth.swift
//  mainProject
//
//  Created by Bryan Kenneth on 06/10/22.
//

import UIKit

class ReusableTextFieldAuth: TextField {
    public private(set) var placeholders: String
    
    init(placeholders: String) {
        self.placeholders = placeholders
        super.init(frame: .zero)
        
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTextField(){
        self.backgroundColor = UIColor.lightGray
        self.attributedPlaceholder = NSAttributedString(string: placeholders)
        self.layer.cornerRadius = 15
    }
}
