//
//  ReusableButton.swift
//  mainProject
//
//  Created by Bryan Kenneth on 01/10/22.
//

import UIKit
import SnapKit

class ReusableButton: UIButton {
    
    //MARK: Initializers
    enum Style{
        case primary
        case secondary
        case primaryDisabled
        case secondaryDisabled
        case delete
    }
    
    public private(set) var style: Style
    public private(set) var buttontext: String
    public private(set) var selector: Selector
    public private(set) var target: Any
    
    init(style: Style, buttonText: String, selector: Selector, target: Any) {
        
        self.style = style
        self.buttontext = buttonText
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
        
        self.setTitle(buttontext, for: .normal)
        
        switch style {
            case .primary:
                self.backgroundColor = UIColor.primaryButtonColor
                self.tintColor = UIColor.whiteColor
            
            case .secondary:
                self.backgroundColor = .clear
                self.layer.borderColor = UIColor.primaryColor?.cgColor
                self.layer.borderWidth = 1.5
                self.setTitleColor(.primaryColor, for: .normal)
                
            case .primaryDisabled:
                self.backgroundColor = UIColor.disabledColor
                self.tintColor = UIColor.whiteColor
                
            case .secondaryDisabled:
                self.backgroundColor = UIColor.clear
                self.layer.borderColor = UIColor.disabledColor?.cgColor
                self.layer.borderWidth = 1.5
                self.tintColor = UIColor.disabledColor
                
            case .delete:
                self.backgroundColor = UIColor.redColor
                self.tintColor = UIColor.whiteColor
        }
        
        self.layer.cornerRadius = 10
        self.titleLabel?.font = UIFont.bodyText()
        self.setTitle(buttontext, for: .normal)
        self.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(UIScreen.main.bounds.width - 40)
        }
    }
    
    public func makeDisabled(isDisabled: Bool) {
        
        self.isEnabled = !isDisabled
        self.backgroundColor = isDisabled ? .disabledColor : .primaryButtonColor
        self.setTitleColor(isDisabled ? .disabledColorButtonText : .whiteColor, for: .normal)
    }
    
    //MARK: Animate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.allowUserInteraction, .curveEaseIn]) {
                self.transform = .init(scaleX: 0.98, y: 0.98)
                self.alpha = 0.9
            }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.allowUserInteraction, .curveEaseOut]) {
                self.transform = .identity
                self.alpha = 1
            }
    }
    
    private func updateColors() {
        self.layer.borderColor = UIColor.primaryColor?.cgColor
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateColors()
        self.setNeedsDisplay()
    }
}
