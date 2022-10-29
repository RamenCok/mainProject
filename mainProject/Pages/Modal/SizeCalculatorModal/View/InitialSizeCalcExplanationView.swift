//
//  InitialSizeCalcExplanationView.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 27/10/22.
//

import UIKit

class InitialSizeCalcExplanationView: UIView {

    // MARK: - Properties
    private lazy var initialImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "sizeCalculatorExplanationEmpty")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    //MARK: - Lifecycle
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        commonInit()
    }

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        
        backgroundColor = .clear
        
        addSubview(initialImage)
        initialImage.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
            make.center.equalTo(self.snp.center)
        }
    }
}
