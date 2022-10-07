//
//  ASHUButton.swift
//  ASHUReusableAsset
//
//  Created by Stephen Giovanni Saputra on 30/09/22.
//

import UIKit
import SnapKit

class ASHUButton: UIButton {

    //MARK: - Initializers
    enum Style {
        case primary
        case secondary
        case destructive
    }

    public private(set) var style: Style
    public private(set) var text: String
    public private(set) var action: Selector
    public private(set) var target: Any
    
    init(isEnabled: Bool, style: Style, text: String, _ action: Selector, _ target: Any) {
        
        self.style = style
        self.text = text
        self.action = action
        self.target = target
        
        super.init(frame: .zero)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func configureButton() {
        
        configureButtonText()
        configureButtonStyle()
        configureButtonTarget()
    }
    
    private func configureButtonStyle() {
        
        switch style {
            case .primary:
                self.backgroundColor = .primaryColor
                self.setTitleColor(.white, for: .normal)
            case .secondary:
                self.backgroundColor = .clear
                self.layer.borderColor = UIColor.primaryColor.cgColor
                self.layer.borderWidth = 1.5
                self.setTitleColor(.primaryColor, for: .normal)
            case .destructive:
                self.backgroundColor = .redColor
                self.setTitleColor(.white, for: .normal)
        }
        
        self.titleLabel?.font = UIFont.bodyText()
        self.layer.cornerRadius = 10
        self.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(UIScreen.main.bounds.width - 40)
        }
    }
    
    private func configureButtonText() {
        setTitle(text, for: .normal)
    }
    
    private func configureButtonTarget() {
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.allowUserInteraction, .curveEaseIn]) {
                self.transform = .init(scaleX: 0.975, y: 0.975)
            }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.allowUserInteraction, .curveEaseOut]) {
                self.transform = .identity
            }
    }
}
