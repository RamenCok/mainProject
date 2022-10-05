//
//  ReusableTextField.swift
//  mainProject
//
//  Created by Bryan Kenneth on 05/10/22.
//

import UIKit

class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
