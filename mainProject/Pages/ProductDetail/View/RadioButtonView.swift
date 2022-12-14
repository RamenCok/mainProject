//
//  RadioButton.swift
//  mainProject
//
//  Created by Kevin Harijanto on 03/10/22.
//

import SnapKit
import UIKit

class RadioButtonView: UIView {
    // MARK: - Properties
    
    private var colorarray: [String]
    var selectedColor: Int
    let border = UIView()
    
    private var radioButton: RadioButtonManager<UIView>?
    private var selectedBorderView: UIView?
    
    weak var delegate: ProductDetailDelegate?
    
    //MARK: - Lifecycle
    
    required init(colorarray: [String], selectedColor: Int) {
        self.colorarray = colorarray
        self.selectedColor = selectedColor
        super.init(frame: .zero)
        
        backgroundColor = .backgroundColor
        configureRadioButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleTapColor(_ sender: UIGestureRecognizer) {
        guard let iv = sender.view else { return }
        radioButton?.selected = iv
        
        guard let getTag = sender.view?.tag else { return }
        selectedColor = getTag
        
        delegate?.changeSelected(selected: getTag)
    }
    
    // MARK: - Helpers
    
    private func createButton(colors: [String])->[UIView]{
        var currentTag = 0
        let colorArray: [UIView] = colors.map { color in
            let circle = UIView()
            circle.setDimensions(height: 24, width: 24)
            circle.layer.cornerRadius = 24 / 2
            circle.backgroundColor = UIColor(color)
            circle.layer.borderColor = UIColor("DBDBDB").cgColor
            circle.layer.borderWidth = 1
            return circle
        }
        
        for color in colorArray {
            color.tag = currentTag
            currentTag += 1
        }
        return colorArray
    }
    
    private func configureRadioButton() {
        let colorArray: [UIView] = createButton(colors: colorarray)
        
        radioButton = RadioButtonManager(
            colorArray,
            onSelected: { [unowned self] color in
                border.setDimensions(height: 30, width: 30)
                border.layer.borderColor = UIColor.blackTexts?.cgColor
                border.layer.borderWidth = 3
                border.layer.cornerRadius = 30 / 2
                
                color.addSubview(border)
                border.snp.makeConstraints { make in
                    make.centerX.centerY.equalTo(color)
                }
                
                selectedBorderView = border
                
            }, onDeselect: { [unowned self] avatar in
                selectedBorderView?.removeFromSuperview()
            })
        // set default selected index to be 0
        radioButton?.selectedIndex = selectedColor
        
        colorArray.forEach { color in
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapColor(_:)))
            // setiap image view harus di tag, baru bisa ambil tag nya
            tap.view?.tag =  color.tag
            color.isUserInteractionEnabled = true
            color.addGestureRecognizer(tap)
        }
        
        configureProductColors(colors: colorArray)
    }
    
    private func configureProductColors(colors: [UIView]) {
        
        let stack = UIStackView()
        for color in colors {
            stack.addArrangedSubview(color)
        }
        stack.axis = .horizontal
        stack.spacing = 13
        stack.distribution = .fill
        self.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.height.equalTo(self)
        }
    }
    
    private func updateColors() {
        border.layer.borderColor = UIColor.blackTexts?.cgColor
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateColors()
        self.setNeedsDisplay()
    }
}
