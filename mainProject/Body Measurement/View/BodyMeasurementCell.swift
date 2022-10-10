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
        bg.layer.shadowColor = UIColor.black.cgColor
        bg.layer.shadowOpacity = 1
        bg.layer.shadowOffset = CGSize.zero
        bg.layer.shadowPath = UIBezierPath(roundedRect: bg.bounds, cornerRadius: 10).cgPath
        bg.layer.shadowRadius = 5
        
        bg.layer.borderWidth = 1
        bg.layer.cornerRadius = 30
        bg.layer.borderColor = UIColor.systemGray4.cgColor
        return bg
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        contentView.backgroundColor = .white
        contentView.addSubview(background)
        
        let measurementType = ReusableLabel(style: .heading_3, textString: converter(type: self.type))
        measurementType.textAlignment = .center
        
        contentView.addSubview(measurementType)
        measurementType.snp.makeConstraints { make in
            make.top.equalTo(background.snp.top).offset(15)
            make.leading.equalTo(background.snp.leading).offset(15)
        }
        
        let measurementNumber = ReusableLabel(style: .subHeading_1, textString: "\(self.numbers!) cm")
        measurementNumber.textAlignment = .left
        contentView.addSubview(measurementNumber)
        measurementNumber.snp.makeConstraints { make in
            make.trailing.equalTo(background.snp.trailing).offset(-20)
            make.bottom.equalTo(background.snp.bottom).offset(-20)
        }
        
        contentView.clipsToBounds = true
        
        background.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        background.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.width)
//        measurementType.frame = CGRect(x: 50, y: contentView.frame.size.width-20, width: contentView.frame.size.width, height: 20)
//        measurementNumber.frame = CGRect(x: 50, y: contentView.frame.size.width, width: contentView.frame.size.width, height: 20)
//    }
}
