//
//  ReusableSizeCalculatorButton.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 06/10/22.
//

import UIKit

class ReusableSizeCalculatorButton: UIButton {

    public private(set) var buttomImage: String
    public private(set) var selector: Selector
    public private(set) var target: Any
    
    init(buttomImage: String, selector: Selector, target: Any) {
        self.buttomImage = buttomImage
        self.selector = selector
        self.target = target
        
        super.init(frame: .zero)
        configureButton()
        configureTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    private func configureTarget(){
        self.addTarget(target, action: selector, for: .touchUpInside)
    }
    
    private func configureButton() {
        
        self.setImage(UIImage(named: buttomImage), for: .normal)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 28
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}
