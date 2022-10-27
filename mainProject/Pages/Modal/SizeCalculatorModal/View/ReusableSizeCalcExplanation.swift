//
//  ReusableSizeCalcExplanation.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 27/10/22.
//

import UIKit
import SnapKit

class ReusableSizeCalcExplanation: UIView {
    
    // MARK: - Properties
    private lazy var overallFitLabel: UILabel = {
        
        let label = ReusableLabel(style: .warningText, textString: "")
        return label
    }()
    
    private lazy var bodyAreaLabel: UILabel = {
        let label = ReusableLabel(style: .heading_2, textString: "")
        return label
    }()
    
    private lazy var productSizeHeadingLabel: UILabel = {
        let label = ReusableLabel(style: .productDetailBrand, textString: "Product Size")
        return label
    }()
    
    private lazy var productSizeResultLabel: UILabel = {
        let label = ReusableLabel(style: .productDetailBrand, textString: "")
        return label
    }()
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return view
    }()
    
    private lazy var mySizeHeadingLabel: UILabel = {
        let label = ReusableLabel(style: .productDetailBrand, textString: "My Size")
        return label
    }()
    
    private lazy var mySizeResultLabel: UILabel = {
        let label = ReusableLabel(style: .productDetailBrand, textString: "20cm")
        return label
    }()
    
    var overallFit: String = ""
    var overallFitColor: UIColor = UIColor.greenColor
    
    var bodyArea: String = ""
    
    var productSize: Int = 0
    var userSize: Int = 0
    
    //MARK: - Lifecycle
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        commonInit()
    }

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
    }
    
    init(overallFit: String, overallFitColor: UIColor, bodyArea: String, resultInt: Int, userSize: Int) {
        
        self.overallFit = overallFit
        self.overallFitColor = overallFitColor
        self.bodyArea = bodyArea
        self.productSize = resultInt
        self.userSize = userSize
        
        super.init(frame: .zero)
        commonInit()
    }
    
    override func awakeFromNib() {
        
        commonInit()
        
        setupOverallFitMessage()
        setupBodyAreaLabel()
        setupProductSizeLabel()
        setupBuyerSizeLabel()
    }
    
    private func commonInit() {
        
        backgroundColor = .clear
        
        addSubview(overallFitLabel)
        overallFitLabel.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(10)
            make.top.equalTo(self.snp.top).offset(10)
        }
        
        addSubview(bodyAreaLabel)
        bodyAreaLabel.snp.makeConstraints { make in
            make.top.equalTo(overallFitLabel.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        addSubview(productSizeHeadingLabel)
        productSizeHeadingLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyAreaLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        addSubview(productSizeResultLabel)
        productSizeResultLabel.snp.makeConstraints { make in
            make.top.equalTo(productSizeHeadingLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(productSizeResultLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        addSubview(mySizeHeadingLabel)
        mySizeHeadingLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        addSubview(mySizeResultLabel)
        mySizeResultLabel.snp.makeConstraints { make in
            make.top.equalTo(mySizeHeadingLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    //MARK: - Helpers
    func setupOverallFitMessage() {

        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "exclamationmark.circle")?.withRenderingMode(.alwaysTemplate)

        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " \(overallFit)"))
        overallFitLabel.attributedText = fullString
        
        overallFitLabel.textColor = overallFitColor
    }
    
    func setupBodyAreaLabel() {
        bodyAreaLabel.text = bodyArea
    }
    
    func setupProductSizeLabel() {
        productSizeResultLabel.text = "\(productSize) cm"
    }
    
    func setupBuyerSizeLabel() {
        mySizeResultLabel.text = "\(userSize) cm"
    }
}
