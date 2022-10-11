//
//  ProductColorView.swift
//  mainProject
//
//  Created by Bryan Kenneth on 09/10/22.
//

import SnapKit
import UIKit

class ProductColorView: UIView {
    // MARK: - Properties
    
    private var colorarray: [String]
    private var radioButton: RadioButtonManager<UIView>?
    private var selectedBorderView: UIView?
    var selected = 0
    
    private var plusLabel: UILabel = {
        let label = ReusableLabel(style: .caption, textString: "")
        return label
    }()
    
    //MARK: - Lifecycle
    
    required init(colorarray: [String]) {
        self.colorarray = colorarray
        super.init(frame: .zero)
        
        backgroundColor = .clear
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
        selected = getTag
        print(selected)
    }
    
    // MARK: - Helpers
    
    private func createButton(colors: [String])->[UIView]{
        var currentTag = 0
        
        let colorArray: [UIView] = colors.map { color in
            let circle = UIView()
            circle.setDimensions(height: 12, width: 12)
            circle.layer.cornerRadius = 12 / 2
            circle.backgroundColor = UIColor(color)
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
                
                
            }, onDeselect: { [unowned self] avatar in
                selectedBorderView?.removeFromSuperview()
            })
        // set default selected index to be 0
        radioButton?.selectedIndex = 0
        
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
            if color.tag <= 2 {
                stack.addArrangedSubview(color)
            }
            
        }
        if colorarray.count > 3{
            plusLabel.text = "+\(colorarray.count - 3)"
            stack.addArrangedSubview(plusLabel)
        }
        
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fill
        
        self.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.height.equalTo(self)
        }
        
       
    }
    
}
