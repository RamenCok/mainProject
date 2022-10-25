//
//  ReusableLabel.swift
//  mainProject
//
//  Created by Bryan Kenneth on 01/10/22.
//

import UIKit

class ReusableLabel: UILabel {

    //MARK: - Initializers
    enum Style {
        case largeTitle_1
        case largeTitle_2
        case heading_1
        case heading_2
        case heading_3
        case subHeading_1
        case subHeading_2
        case bodyText
        case caption
        case warningText
        case productDetailBrand
        case modalTitle
    }
    
    public private(set) var style: Style
    public private(set) var textString: String
    
    init(style: Style, textString: String) {
        
        self.style = style
        self.textString = textString
        
        super.init(frame: .zero)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        
        configureLabelText()
        configureLabelStyle()
    }
    
    private func configureLabelText() {
        self.text = textString
    }
    
    //MARK: - Methods
    private func configureLabelStyle() {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = 1.0

        let hyphenAttribute = [
            NSAttributedString.Key.paragraphStyle : paragraphStyle,
        ] as [NSAttributedString.Key : Any]
        
        switch style {
            case .largeTitle_1:
                self.font = UIFont.largeTitle_1()
            
            case .largeTitle_2:
                self.font = UIFont.largeTitle_2()
            
            case .heading_1:
                self.font = UIFont.heading_1()
            
            case .heading_2:
                self.font = UIFont.heading_2()
                
            case .heading_3:
                self.font = UIFont.heading_3()
                
            case .subHeading_1:
                self.font = UIFont.subHeading_1()
                
            case .subHeading_2:
                self.font = UIFont.subHeading_2()
            
                paragraphStyle.minimumLineHeight = 27
                paragraphStyle.maximumLineHeight = 27
                self.attributedText = NSAttributedString(
                    string: textString,
                    attributes: [
                        .paragraphStyle: paragraphStyle
                    ])
                
            case .bodyText:
                self.font = UIFont.bodyText()
                
            case .caption:
                self.font = UIFont.caption()
                
            case .warningText:
                self.font = UIFont.warningText()
                
            case .productDetailBrand:
                self.font = UIFont.productDetailBrand()
                
            case .modalTitle:
                self.font = UIFont.modalTitle()
        }
        
        self.textColor = .blackTexts
        self.numberOfLines = 100
        let attributedString = NSMutableAttributedString(string: textString, attributes: hyphenAttribute)
        self.attributedText = attributedString
    }
}
