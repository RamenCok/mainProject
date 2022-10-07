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
    
    //System-Based Color
    static let primaryColor = UIColor.rgb(red: 35, green: 49, blue: 97, alpha: 1)
    static let secondaryColor = UIColor.rgb(red: 51, green: 70, blue: 178, alpha: 1)
    static let tertiaryColor = UIColor.rgb(red: 221, green: 74, blue: 162, alpha: 1)
    static let disabledColor = UIColor.rgb(red: 188, green: 198, blue: 232, alpha: 1)
    static let whiteColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
    static let blackTexts = UIColor.rgb(red: 35, green: 35, blue: 35, alpha: 1)
    static let tesColor = UIColor.rgb(red: 231, green: 231, blue: 231, alpha: 1)
    
    //Color-based Color
    static let greyColor = UIColor.rgb(red: 73, green: 73, blue: 73, alpha: 1)
    static let redColor = UIColor.rgb(red: 215, green: 87, blue: 87, alpha: 1)
    static let greenColor = UIColor.rgb(red: 155, green: 217, blue: 117, alpha: 1)
    static let microRed = UIColor.rgb(red: 215, green: 87, blue: 87, alpha: 0.2)
    static let microGreen = UIColor.rgb(red: 169, green: 225, blue: 134, alpha: 0.2)
    static let lightGray = UIColor.rgb(red: 249, green: 249, blue: 249, alpha: 1)
    
    // Convert hex to UIColor
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") { cString.removeFirst() }
        
        if cString.count != 6 {
            self.init("ff0000") // return red color for wrong hex input
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}




extension UIView {
    convenience public init(backgroundColor: UIColor = .clear) {
        
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        
        mask.path = path.cgPath
        layer.mask = mask
    }
    
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
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
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
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}
