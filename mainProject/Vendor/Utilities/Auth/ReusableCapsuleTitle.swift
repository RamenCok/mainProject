//
//  ReusableCapsuleTitle.swift
//  mainProject
//
//  Created by Bryan Kenneth on 05/10/22.
//

import UIKit

class ReusableCapsuleTitle: UIStackView {
    public private(set) var textString: String
    
    
    init(title: String) {
        
        self.textString = title
        super.init(frame: .zero)
        configureStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureStackView(){
        let label = ReusableLabel(style: .largeTitle_2, textString: textString)
        let view = ResuablePinkCapsule()
        
        self.addArrangedSubview(view)
        self.addArrangedSubview(label)
        self.axis = .vertical
        self.alignment = .leading
    }
}
