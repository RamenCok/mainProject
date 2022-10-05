//
//  ReusableErrorLabel.swift
//  mainProject
//
//  Created by Bryan Kenneth on 05/10/22.
//

import UIKit


class ReusableErrorLabel: UILabel {
    public private(set) var textString: String
    
    init(text: String) {
        self.textString = text
        super.init(frame: .zero)
        
        configureText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureText() {
        
    }
}
