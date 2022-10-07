//
//  ReusableErrorLabel.swift
//  mainProject
//
//  Created by Bryan Kenneth on 05/10/22.
//

import UIKit
import SnapKit

class ReusableErrorLabel: UIView {
    public private(set) var textString: String
    private let imageView = UIImageView()
    private var textLabel = UILabel()

    init(text: String) {
        self.textString = text
        super.init(frame: .zero)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
       
        imageView.image = UIImage(systemName: "circle")
        imageView.tintColor = .redColor
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.height.equalTo(19)
            make.width.equalTo(19)
        }
        
        textLabel = ReusableLabel(style: .caption, textString: textString)
        textLabel.textColor = .redColor
        
        self.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(3)
            make.trailing.equalTo(self.snp.trailing)
        }
    }
    
    func updateImage(newImage: String, success: Bool){
        if success {
            imageView.image = UIImage(systemName: newImage)
            imageView.tintColor = .greenColor
            textLabel.textColor = .greenColor
        } else {
            imageView.image = UIImage(systemName: newImage)
            imageView.tintColor = .redColor
            textLabel.textColor = .redColor
        }
        
    }
}
