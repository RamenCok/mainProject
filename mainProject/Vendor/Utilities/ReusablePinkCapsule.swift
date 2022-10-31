//
//  ReusablePinkCapsule.swift
//  mainProject
//
//  Created by Bryan Kenneth on 05/10/22.
//

import UIKit
import SnapKit

class ResuablePinkCapsule: UIView {
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.tertiaryColor
        self.snp.makeConstraints { make in
                make.height.equalTo(25)
                make.width.equalTo(82)
        }
        self.layer.cornerRadius = 12.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
