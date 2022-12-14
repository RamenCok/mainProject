//
//  ProductDetail.swift
//  mainProject
//
//  Created by Kevin Harijanto on 04/10/22.
//

import UIKit
import SceneKit
import SceneKit.ModelIO
import Combine
import Firebase

protocol ProductDetailDelegate: AnyObject {
    
    func showSizeCalc()
    func showBuyModal()
    func changeSelected(selected: Int)
    func goToBodyMeasurement()
}

class ProductDetailVC: UIViewController {
    
    // MARK: - Properties
    private var vm = ARModelsViewModel()
    private var profilevm = ProfileViewModel(service: Service())
    private var cancellables: Set<AnyCancellable> = []
    
    private var user: User!
    private var brandName: String!
    private var product: Product!
    private var urlFile: URL!
    
    private var selectedIndex = 0
    
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
    
    private lazy var sceneKitView: SCNView = {
        let view = SCNView()
        view.allowsCameraControl = true
        view.backgroundColor = .whiteColor
        return view
    }()
    
    private lazy var imageRotate: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "assetRotate")
        return image
    }()
    
    private let viewInAR: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.rgb(red: 35, green: 49, blue: 97, alpha: 1)
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
    
    private lazy var topRectangle: UIView = {
        let rect = UIView()
        rect.backgroundColor = .backgroundColor
        return rect
    }()
    
    private lazy var bottomRectangle: UIView = {
        let rect = UIView()
        rect.backgroundColor = .backgroundColor
        return rect
    }()
    
    private lazy var progressView: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .default)
        pv.trackTintColor = .lightGray
        pv.tintColor = .primaryButtonColor
        return pv
    }()
    
    var modalSize: Double?
    var presentedVC: String?
    
    // MARK: - Lifecycle
    override open func viewDidLoad() {
        
        view.backgroundColor = .backgroundColor
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .navBar
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.whiteColor,
            .font: UIFont.heading_1()
        ]
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.blackTexts!,
            .font: UIFont.modalTitle()
        ]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .primaryColor
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        
        UIApplication.shared.statusBarStyle = .darkContent
        
        super.viewDidLoad()
        
        self.navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = UIColor.rgb(red: 35, green: 49, blue: 97, alpha: 1)
        
        setupScrollView()
        
        configureProgressView()
        progressView.alpha = 0
        
        vm.model.sink { [weak self] url in
            print("DEBUG: Called in view")
            self?.setup3D(url: url)
            self?.urlFile = url
        }.store(in: &cancellables)
        
        vm.isDownloading.sink { [weak self] isDownloading in
            if isDownloading {
                self?.progressView.alpha = 1
                self?.sceneKitView.alpha = 0
                self?.viewInAR.alpha = 0
            } else {
                self?.progressView.alpha = 0
                self?.sceneKitView.alpha = 1
                self?.viewInAR.alpha = 1
            }
        }.store(in: &cancellables)
        
        vm.percentage.sink { [weak self] progress in
            self?.progressView.setProgress(progress, animated: true)
        }.store(in: &cancellables)
        
        profilevm.user.sink { [weak self] user in
            self?.user = user
        }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        vm.asyncLoadModel(filename: product.colorsAsset.compactMap { ($0["assetLink"] as! String)}[selectedIndex])
        
        profilevm.getUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }
    
    // MARK: - Selectors
    
    @objc func handleARButton() {
        let rootVC = ARViewController(filename: urlFile)
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
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
        scrollView.delegate = self
        
        configureContentView()
        
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
        }
    }
    
    private func configureProgressView() {
        contentView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.center.equalTo(topRectangle)
            make.width.equalTo(topRectangle.snp.width).inset(40)
        }
    }
    
    private func configureContentView() {
        
        contentView.addSubview(topRectangle)
        topRectangle.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(view.frame.height * 0.448)
        }
        
        contentView.addSubview(sceneKitView)
        sceneKitView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(view.frame.height * 0.448)
        }
        
        contentView.addSubview(imageRotate)
        imageRotate.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(27)
            make.bottom.equalTo(sceneKitView.snp.bottom).offset(-10)
            make.leading.equalTo(sceneKitView.snp.leading).offset(10)
        }
        
        contentView.addSubview(bottomRectangle)
        bottomRectangle.snp.makeConstraints { make in
            make.top.equalTo(topRectangle.snp.bottom)
            make.width.height.equalTo(contentView.snp.height)
        }
        bottomRectangle.setupShadow(opacity: 0.15, radius: 58, offset: CGSize(width: 1, height: 8), color: .systemGray)
//        bottomRectangle.backgroundColor = .yellow
        contentView.addSubview(viewInAR)
        
        viewInAR.snp.makeConstraints { make in
            make.bottom.equalTo(bottomRectangle.snp.top).offset(view.frame.height * -0.014)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.width.equalTo(view.frame.width * 0.374)
            make.height.equalTo(view.frame.height * 0.053)
        }
        
        let productHeadline = HeadlineView(brandName: brandName, product: product)
        contentView.addSubview(productHeadline)
//        productHeadline.backgroundColor = .red
        productHeadline.snp.makeConstraints { make in
            make.top.equalTo(topRectangle.snp.bottom).offset(view.frame.height * 0.02)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }

        let RadioButton = RadioButtonView(colorarray: product.colorsAsset.compactMap { $0["colors"] as? String }, selectedColor: selectedIndex)
        RadioButton.delegate = self
//        RadioButton.backgroundColor = .blue
        contentView.addSubview(RadioButton)
        RadioButton.snp.makeConstraints { make in
            make.top.equalTo(productHeadline.snp.bottom).offset(view.frame.height * 0.02)
            make.leading.equalTo(contentView.snp.leading).offset(20)
        }
        
        let productDescription = DescriptionView(productDesc: product.productDesc.replacingOccurrences(of: "\\n", with: "\n"))
        contentView.addSubview(productDescription)
//        productDescription.backgroundColor = .green
        productDescription.snp.makeConstraints { make in
            make.top.equalTo(RadioButton.snp.bottom).offset(view.frame.height * 0.02)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    private func setup3D(url: URL) {
        let scene = try! SCNScene(url: url, options: [.checkConsistency: true])
        let light = SCNNode()
        light.light = SCNLight()
        light.light?.type = .ambient
        light.light?.temperature = 6700
    
        sceneKitView.scene = scene
        scene.rootNode.addChildNode(light)
        let camera = SCNNode()
        camera.camera = SCNCamera()
        scene.rootNode.addChildNode(camera)
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
        var sizeMeasurementExist = false
        
        // Checking for Authentication of User
        if let user = Auth.auth().currentUser {
            if user.isAnonymous {
                let slideVC = SignUpModalVC()
                slideVC.delegate = self
                presentedVC = slideVC.modalType
                modalSize = slideVC.modalSize
                slideVC.modalPresentationStyle = .custom
                slideVC.transitioningDelegate = self
                
                self.present(slideVC, animated: true, completion: nil)
            } else {
                
                if self.user.userBodyMeasurement.values.contains(0) {
                    sizeMeasurementExist = false
                } else {
                    sizeMeasurementExist = true
                }
            }
        }
        
        // Checking for Size Measurement of User
        if sizeMeasurementExist {
            print("product size: \(product.productSizeChart)")
            print("product: \(product)")
            print(product.productSizeChart)
            print(product)
            let slideVC = SizeCalculatorModalVC(productSizeChart: product.productSizeChart, brandName: brandName, productName: product.productName)
            
            presentedVC = slideVC.modalType
            modalSize = slideVC.modalSize
            slideVC.modalPresentationStyle = .custom
            slideVC.transitioningDelegate = self
            
            self.present(slideVC, animated: true, completion: nil)
            
        } else {
            let slideVC = BodyMeasurementModalVC()
            slideVC.delegate = self
            presentedVC = slideVC.modalType
            modalSize = slideVC.modalSize
            slideVC.modalPresentationStyle = .custom
            slideVC.transitioningDelegate = self
            
            self.present(slideVC, animated: true, completion: nil)
        }
    }
    
    func showBuyModal() {
        
        let slideVC = BuyModalVC(productLinks: product.productLinks)
        
        presentedVC = slideVC.modalType
        modalSize = slideVC.vm.setModalHeight(numberOfButtons: 4)
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        
        self.present(slideVC, animated: true, completion: nil)
    }
    
    func changeSelected(selected: Int) {
        if selectedIndex != selected {
            selectedIndex = selected
            
            // reload view
            vm.asyncLoadModel(filename: product.colorsAsset.compactMap { ($0["assetLink"] as! String)}[selectedIndex])
            progressView.setProgress(0, animated: false)
        }
    }
    
    func goToBodyMeasurement() {
        self.navigationController?.pushViewController(BodyMeasurementVC(user: user), animated: true)
    }
}

extension ProductDetailVC:ProductCatalogueDelegate {
    func goToSignUp() {
        self.navigationController?.pushViewController(SignupLogin(), animated: true)
    }
    
    func skip() {
        self.dismiss(animated: true)
    }
}

extension ProductDetailVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > 0 {
            let currentTheme = self.traitCollection.userInterfaceStyle
            
            switch currentTheme {
                case .dark:
                    UIApplication.shared.statusBarStyle = .lightContent
                case .light:
                    UIApplication.shared.statusBarStyle = .darkContent
                default:
                    UIApplication.shared.statusBarStyle = .darkContent
            }
            
            navigationController?.navigationBar.tintColor = .primaryColor
        } else {
            navigationController?.navigationBar.tintColor = UIColor.rgb(red: 35, green: 49, blue: 97, alpha: 1)
            UIApplication.shared.statusBarStyle = .darkContent
        }
    }
}
