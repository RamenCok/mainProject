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
    
    var type: Int!
    var numbers: Int!
    
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
        
        let measurementType = ReusableLabel(style: .heading_3, textString: converter(type: self.type))
        measurementType.textAlignment = .left
        contentView.addSubview(measurementType)
        measurementType.snp.makeConstraints { make in
            make.top.equalTo(background.snp.top).offset(15)
            make.leading.equalTo(background.snp.leading).offset(15)
        }
        
        let measurementCaption = ReusableLabel(style: .bodyText, textString: "Caption")
        measurementType.textAlignment = .left
        contentView.addSubview(measurementCaption)
        measurementCaption.snp.makeConstraints { make in
            make.top.equalTo(measurementType.snp.bottom).offset(3)
            make.leading.equalTo(background.snp.leading).offset(15)
        }
            
        let measurementNumber = ReusableLabel(style: .subHeading_1, textString: dash())
        measurementNumber.textAlignment = .left
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
    
    private func converter(type: Int)->String {
        switch type {
        case 0:
            return "Bust"
        case 1:
            return "Waist"
        case 2:
            return "Height"
        case 3:
            return "Hips"
        case 4:
            return "Arm"
        case 5:
            return "Thigh"
        case 6:
            return "Shoulder"
        case 7:
            return "Sleeve"
        default:
            return ""
        }
    }
}
