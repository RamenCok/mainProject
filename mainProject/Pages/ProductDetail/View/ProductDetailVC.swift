//
//  ProductDetail.swift
//  mainProject
//
//  Created by Kevin Harijanto on 04/10/22.
//

import UIKit
import Combine

protocol ProductDetailDelegate: AnyObject {
    
    func showSizeCalc()
    func showBuyModal()
}

class ProductDetailVC: UIViewController {
    
    // MARK: - Properties
    var productDetailVM = ProductDetailVM(service: ProductService())
    private var brandName: String!
    private var product: Product!
    private var cancellables: Set<AnyCancellable> = []
    private var filename: String!
    private var selectedColor = 0
    
    init(brandName: String, product: Product) {
        self.brandName = brandName
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let viewInAR: UIButton = {
        let button = UIButton()
        button.backgroundColor = .primaryColor
        button.layer.cornerRadius = 45 / 2
        button.setTitleColor(.white, for: .normal)
        button.setTitle("View in AR", for: .normal)
        button.titleLabel?.font = UIFont.bodyText()
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        button.setImage(UIImage(named: "ARicon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.addTarget(self, action: #selector(handleARButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var rectangle: UIView = {
        let rect = UIView()
        rect.backgroundColor = .systemBackground
        return rect
    }()
    
    var modalSize: Double?
    var presentedVC: String?
    
    // MARK: - Lifecycle
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        Task.init {
            await productDetailVM.fetch3DAsset(path: product.colorsAsset.compactMap { $0["assetLink"] as? String }[0])
            setupScrollView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Selectors
    
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
            make.bottom.equalToSuperview().offset(view.frame.height * -0.194)
        }
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.addSubview(contentView)
        self.contentView.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.width.equalTo(scrollView.snp.width)
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom).offset(view.frame.height * -0.023)
        }
        
        let buyandsize = BuyAndSizeView()
        buyandsize.delegate = self
        view.addSubview(buyandsize)
        buyandsize.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalTo(scrollView.snp.bottom)
            make.bottom.equalToSuperview()
            make.height.equalTo(view.frame.height * 0.194)
            print(view.frame.height * 0.194)
        }

        configureContainerView()
    }
    
    private func configureContainerView() {
//        let ArView = ARView(filename: filename)
        print("DEBUG: int2 \(selectedColor)")
        let ArView = ARView(filename: product.colorsAsset.compactMap { $0["assetLink"] as? String }[selectedColor])
        contentView.addSubview(ArView)
        ArView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(view.frame.height * 0.448)
        }
        
        contentView.addSubview(rectangle)
        rectangle.snp.makeConstraints { make in
            make.top.equalTo(ArView.snp.bottom)
            make.width.height.equalTo(contentView.snp.height)
        }
        rectangle.setupShadow(opacity: 0.15, radius: 58, offset: CGSize(width: 1, height: 8), color: .systemGray)
        
        contentView.addSubview(viewInAR)
        viewInAR.snp.makeConstraints { make in
            make.bottom.equalTo(rectangle.snp.top).offset(view.frame.height * -0.014)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.width.equalTo(view.frame.width * 0.374)
            make.height.equalTo(view.frame.height * 0.053)
        }
        
        let productHeadline = HeadlineView(brandName: brandName, productName: product.productName)
        contentView.addSubview(productHeadline)
        productHeadline.snp.makeConstraints { make in
            make.top.equalTo(ArView.snp.bottom).offset(view.frame.height * 0.02)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }

        let RadioButton = RadioButtonView(colorarray: product.colorsAsset.compactMap { $0["colors"] as? String }, selectedColor: selectedColor)
        contentView.addSubview(RadioButton)
        RadioButton.snp.makeConstraints { make in
            make.top.equalTo(productHeadline.snp.bottom).offset(view.frame.height * 0.02)
            make.leading.equalTo(contentView.snp.leading).offset(20)
        }
        
        let productDescription = DescriptionView(productDesc: product.productDesc)
        contentView.addSubview(productDescription)
        productDescription.snp.makeConstraints { make in
            make.top.equalTo(RadioButton.snp.bottom).offset(view.frame.height * 0.02)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}

extension ProductDetailVC: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        if presentedVC == "Tappable" {
            return DismissTappablePresentationController(
                modalTransitionSize: (view.frame.height/self.modalSize!)/view.frame.height,
                presentedViewController: presented,
                presenting: presenting
            )
        } else {
            return NotTappablePresentationController(
                modalTransitionSize: (view.frame.height/self.modalSize!)/view.frame.height,
                presentedViewController: presented,
                presenting: presenting
            )
        }
    }
}

extension ProductDetailVC: ProductDetailDelegate {
    
    func showSizeCalc() {
        
        let slideVC = SizeCalculatorModalVC(productSizeChart: product.productSizeChart)
        
        presentedVC = slideVC.modalType
        modalSize = slideVC.modalSize
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        
        self.present(slideVC, animated: true, completion: nil)
    }
    
    func showBuyModal() {
        
        let slideVC = BuyModalVC()
        
        presentedVC = slideVC.modalType
        modalSize = slideVC.vm.setModalHeight(numberOfButtons: 4)
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        
        self.present(slideVC, animated: true, completion: nil)
    }
}
