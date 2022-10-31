//
//  ReusableAuthBackground.swift
//  mainProject
//
//  Created by Bryan Kenneth on 05/10/22.
//

import UIKit

class AuthBackground: UIImageView{
    init() {
        super.init(frame: .zero)
        self.image = UIImage(named: "bg-auth")
        self.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
