//
//  BodyMeasurementCell.swift
//  mainProject
//
//  Created by Kevin Harijanto on 06/10/22.
//

import UIKit
import SnapKit

class BodyMeasurementCell: UICollectionViewCell {
    
    static let identifier = "BodyMeasurementCell"
    
    var type: String!
    var numbers: Int!
    
    var disabledHighlightedAnimation = false
    
    // MARK: - Cell animation when touched
    func freezeAnimations() {
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }
    
    func unfreezeAnimations() {
        disabledHighlightedAnimation = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        if disabledHighlightedAnimation {
            return
        }
        if isHighlighted {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: [.allowUserInteraction], animations: {
                self.transform = .init(scaleX: 0.96, y: 0.96)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: [.allowUserInteraction], animations: {
                self.transform = .identity
            }, completion: completion)
        }
    }
    
    private lazy var background: UIView = {
        let bg = UIView()
        
        bg.backgroundColor = .white
        bg.layer.cornerRadius = 30
        
        bg.layer.borderWidth = 1
        bg.layer.borderColor = UIColor.systemGray5.cgColor
        return bg
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {

        contentView.addSubview(background)
        
        let measurementType = ReusableLabel(style: .heading_3, textString: self.type)
        measurementType.textAlignment = .left
        measurementType.textColor = .black
        contentView.addSubview(measurementType)
        measurementType.snp.makeConstraints { make in
            make.top.equalTo(background.snp.top).offset(15)
            make.leading.equalTo(background.snp.leading).offset(15)
        }
        
        let measurementCaption = ReusableLabel(style: .bodyText, textString: "")
        measurementCaption.textAlignment = .left
        measurementCaption.textColor = .black
        contentView.addSubview(measurementCaption)
        measurementCaption.snp.makeConstraints { make in
            make.top.equalTo(measurementType.snp.bottom).offset(3)
            make.leading.equalTo(background.snp.leading).offset(15)
        }
            
        let measurementNumber = ReusableLabel(style: .subHeading_1, textString: dash())
        measurementNumber.textAlignment = .left
        measurementNumber.textColor = .black
        contentView.addSubview(measurementNumber)
        measurementNumber.snp.makeConstraints { make in
            make.trailing.equalTo(background.snp.trailing).offset(-20)
            make.bottom.equalTo(background.snp.bottom).offset(-20)
        }
        
        contentView.clipsToBounds = true
        
        background.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
    }
    
    private func dash() -> String {
        if self.numbers != 0 {
            return "\(self.numbers!) cm"
        } else {
            return "-"
        }
    }
    
    private func updateColors() {
        self.background.layer.borderColor = UIColor.systemGray5.cgColor
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateColors()
        self.setNeedsDisplay()
    }
}
