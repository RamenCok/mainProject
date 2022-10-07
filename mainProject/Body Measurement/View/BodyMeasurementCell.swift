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
        bg.layer.borderColor = UIColor.black.cgColor
        return bg
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        print(self.type)
        contentView.backgroundColor = .clear
        contentView.addSubview(background)
        
        let measurementType = ReusableLabel(style: .heading_3, textString: converter(type: self.type))
        measurementType.textAlignment = .center
        contentView.addSubview(measurementType)
        
        let measurementNumber = ReusableLabel(style: .subHeading_1, textString: "\(self.numbers!) cm")
        measurementNumber.textAlignment = .left
        contentView.addSubview(measurementNumber)
        contentView.clipsToBounds = true
        
        background.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.width)
        measurementType.frame = CGRect(x: 50, y: contentView.frame.size.width-20, width: contentView.frame.size.width, height: 20)
        measurementNumber.frame = CGRect(x: 50, y: contentView.frame.size.width, width: contentView.frame.size.width, height: 20)
    }
    
    private func converter(type: Int)->String {
        switch type {
        case 0:
            return "bust"
        case 1:
            return "waist"
        case 2:
            return "height"
        case 3:
            return "hips"
        case 4:
            return "arm"
        case 5:
            return "thigh"
        case 6:
            return "shoulder"
        case 7:
            return "sleeve"
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
