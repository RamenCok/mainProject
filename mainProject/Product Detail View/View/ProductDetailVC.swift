//
//  ProductDetail.swift
//  mainProject
//
//  Created by Kevin Harijanto on 04/10/22.
//

import UIKit

class ProductDetailVC: UIViewController {
    
    // MARK: - Properties
    var vm: ProductDetailVM!
    
    var colorsArrayTest = [String]()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let ArView: UIView = {
        let view = ARView()
        return view
    }()
    
    private let viewInAR: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("View in AR", for: .normal)
        button.backgroundColor = .primaryColor
        button.layer.cornerRadius = 45 / 2
        button.addTarget(self, action: #selector(handleARButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont.bodyText()
        button.setImage(UIImage(named: "ARicon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        return button
    }()
    
    private lazy var rectangle: UIView = {
        let rect = UIView()
        rect.backgroundColor = .systemBackground
        return rect
    }()
    
    private lazy var brandName: UILabel = {
        let label = ReusableLabel(style: .productDetailBrand, textString: "")
        label.textColor = .systemGray3
        return label
    }()
    
    private lazy var productName: UILabel = {
        let label = ReusableLabel(style: .heading_2, textString: "")
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var productInfo: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [brandName, productName])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 3
        return stackView
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up")?.scalePreservingAspectRatio(targetSize: CGSize(width: 27, height: 27)), for: .normal)
        button.addTarget(self, action: #selector(handleShareButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var productHeadline: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productInfo, shareButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var productDescription: UILabel = {
        let label = ReusableLabel(style: .bodyText, textString: "")
        label.numberOfLines = 0
        return label
    }()
    // MARK: - Lifecycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Panggil dari vm
        vm.updatedData = { [weak self] data in
            self?.brandName.text = "\(data.brandName)"
            self?.productName.text = "\(data.productName)"
            self?.colorsArrayTest = data.colorsArray
            self?.productDescription.text = "\(data.productDesc)"
            self?.setupScrollView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.fetchData()
    }
    
    // MARK: - Selectors
    @objc func handleShareButton() {
        print("Share")
    }
    
    @objc func handleBackButton() {
        print("Back")
    }
    
    @objc func handleARButton() {
        print("AR Button")
    }
    
    // MARK: - Helpers
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-164)
        }
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.addSubview(contentView)
        self.contentView.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.width.equalTo(scrollView.snp.width)
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom).offset(-20)
        }
        
        let buyandsize = BuyAndSizeView()
        view.addSubview(buyandsize)
        buyandsize.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalTo(scrollView.snp.bottom)
            make.bottom.equalToSuperview()
        }

        configureContainerView()
    }
    
    private func configureContainerView() {

        contentView.addSubview(ArView)
        ArView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(view.frame.height * 0.4480094787)
        }
        
        contentView.addSubview(rectangle)
        rectangle.snp.makeConstraints { make in
            make.top.equalTo(ArView.snp.bottom)
            make.width.height.equalTo(contentView.snp.height)
        }
        rectangle.setupShadow(opacity: 0.15, radius: 58, offset: CGSize(width: 1, height: 8), color: .systemGray)
        
        contentView.addSubview(viewInAR)
        viewInAR.snp.makeConstraints { make in
            make.bottom.equalTo(rectangle.snp.top).offset(-12)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.width.equalTo(146)
            make.height.equalTo(45)
        }
        
        contentView.addSubview(productHeadline)
        productHeadline.snp.makeConstraints { make in
            make.top.equalTo(ArView.snp.bottom).offset(17)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }

        let RadioButton = RadioButtonView(colorarray: colorsArrayTest)
        contentView.addSubview(RadioButton)
        RadioButton.snp.makeConstraints { make in
            make.top.equalTo(productHeadline.snp.bottom).offset(17)
            make.leading.equalTo(contentView.snp.leading).offset(20)
        }
        
        contentView.addSubview(productDescription)
        productDescription.snp.makeConstraints { make in
            make.top.equalTo(RadioButton.snp.bottom).offset(17)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
}

