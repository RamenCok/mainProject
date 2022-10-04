//
//  Extensions.swift
//  mainProject
//
//  Created by Bryan Kenneth on 01/10/22.
//


import Foundation
import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static let textColor = UIColor(named: "textColor")
    static let backgroundColor = UIColor(named: "backgroundColor")
    
    //System-Based Color
    static let primaryColor = UIColor.rgb(red: 35, green: 49, blue: 97, alpha: 1)
    static let secondaryColor = UIColor.rgb(red: 51, green: 70, blue: 178, alpha: 1)
    static let tertiaryColor = UIColor.rgb(red: 221, green: 74, blue: 162, alpha: 1)
    static let disabledColor = UIColor.rgb(red: 188, green: 198, blue: 232, alpha: 1)
    static let whiteColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
    static let blackTexts = UIColor.rgb(red: 35, green: 35, blue: 35, alpha: 1)
    static let tesColor = UIColor.rgb(red: 231, green: 231, blue: 231, alpha: 1)
    
    //Colo-based Color
    static let greyColor = UIColor.rgb(red: 73, green: 73, blue: 73, alpha: 1)
    static let redColor = UIColor.rgb(red: 215, green: 87, blue: 87, alpha: 1)
    static let greenColor = UIColor.rgb(red: 155, green: 217, blue: 117, alpha: 1)
    static let microRed = UIColor.rgb(red: 215, green: 87, blue: 87, alpha: 0.2)
    static let microGreen = UIColor.rgb(red: 169, green: 225, blue: 134, alpha: 0.2)
    
}

extension UIView {
    
    func setupShadow(
        opacity: Float = 0,
        radius: CGFloat = 0,
        offset: CGSize = .zero,
        color: UIColor = .black) {
        
            layer.shadowOpacity = opacity
            layer.shadowRadius = radius
            layer.shadowOffset = offset
            layer.shadowColor = color.cgColor
    }
    
    convenience public init(backgroundColor: UIColor = .clear) {
        
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
}

extension UIFont {
    
    static func largeTitle_1() -> UIFont {
        
        guard let customFont = UIFont(name: "Sora-Bold", size: 44) else {
            return UIFont.systemFont(ofSize: 44)
        }
        
        return customFont
    }
    
    static func largeTitle_2() -> UIFont {
        
        guard let customFont = UIFont(name: "Sora-Bold", size: 36) else {
            return UIFont.systemFont(ofSize: 36)
        }
        
        return customFont
    }
    
    static func heading_1() -> UIFont {
        
        guard let customFont = UIFont(name: "Sora-Bold", size: 32) else {
            return UIFont.systemFont(ofSize: 32)
        }
        
        return customFont
    }
    
    static func heading_2() -> UIFont {
        
        guard let customFont = UIFont(name: "Sora-Bold", size: 26) else {
            return UIFont.systemFont(ofSize: 26)
        }
        
        return customFont
    }
    
    static func heading_3() -> UIFont {
        
        guard let customFont = UIFont(name: "Sora-Bold", size: 24) else {
            return UIFont.systemFont(ofSize: 24)
        }
        
        return customFont
    }
    
    static func subHeading_1() -> UIFont {
        
        guard let customFont = UIFont(name: "Sora-Regular", size: 20) else {
            return UIFont.systemFont(ofSize: 20)
        }
        
        return customFont
    }
    
    static func subHeading_2() -> UIFont {
        
        guard let customFont = UIFont(name: "Sora-Regular", size: 18) else {
            return UIFont.systemFont(ofSize: 18)
        }
        
        return customFont
    }
    
    static func bodyText() -> UIFont {
        
        guard let customFont = UIFont(name: "Sora-Regular", size: 16) else {
            return UIFont.systemFont(ofSize: 16)
        }
        
        return customFont
    }
    
    static func caption() -> UIFont {
        
        guard let customFont = UIFont(name: "Sora-Regular", size: 14) else {
            return UIFont.systemFont(ofSize: 14)
        }
        
        return customFont
    }
    
    static func warningText() -> UIFont {
        
        guard let customFont = UIFont(name: "Sora-Bold", size: 12) else {
            return UIFont.systemFont(ofSize: 12)
        }
        
        return customFont
    }
    
    static func productDetailBrand() -> UIFont {
        
        guard let customFont = UIFont(name: "Sora-SemiBold", size: 14) else {
            return UIFont.systemFont(ofSize: 14)
        }
        
        return customFont
    }
    
    static func modalTitle() -> UIFont {
        
        guard let customFont = UIFont(name: "Sora-Bold", size: 16) else {
            return UIFont.systemFont(ofSize: 16)
        }
        
        return customFont
    }
}

extension UITextField {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(
            frame: CGRect(
                x: 0.0,
                y: 0.0,
                width: UIScreen.main.bounds.size.width,
                height: 44.0)
        )
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}

extension UIView {
    
    func pinToParent(parent: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parent.topAnchor),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ])
    }
    
    func removeAllSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
}
