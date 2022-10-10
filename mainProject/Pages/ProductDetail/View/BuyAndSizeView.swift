//
//  BuySizeView.swift
//  mainProject
//
//  Created by Kevin Harijanto on 05/10/22.
//

import Foundation
import UIKit

class BuyAndSizeView: UIView {
    // MARK: - Properties
    private lazy var rectangle: UIView = {
        let rect = UIView()
        rect.backgroundColor = .systemBackground
        return rect
    }()
    
    private let buyButton: UIButton = {
        let button = ReusableButton(style: .primary, buttonText: "Buy", selector: #selector(handleBuyButton), target: self)
        return button
    }()
    
    private let sizeCalcButton: UIButton = {
        let button = ReusableButton(style: .secondary, buttonText: "Size Calculator", selector: #selector(handleSizeCalculator), target: self)
        button.setTitleColor(.primaryColor, for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle
    required init() {
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers
    private func configureUI() {
        addSubview(rectangle)
        rectangle.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.height.equalTo(self)
        }
        rectangle.setupShadow(opacity: 0.28, radius: 58, offset: CGSize(width: 1, height: 8), color: .systemGray)
        
        addSubview(buyButton)
        buyButton.snp.makeConstraints { make in
            make.top.equalTo(rectangle.snp.top).offset(20)
            make.centerX.equalTo(self)
            make.height.equalTo(47)
        }

        addSubview(sizeCalcButton)
        sizeCalcButton.snp.makeConstraints { make in
            make.top.equalTo(buyButton.snp.bottom).offset(10)
            make.centerX.equalTo(self)
            make.height.equalTo(47)
        }
    }
    
    // MARK: - Selectors
    @objc func handleBuyButton() {
        print("Buy modal popout")
    }
    
    @objc func handleSizeCalculator() {
        print("Size calc modal popout")
    }
    
}
