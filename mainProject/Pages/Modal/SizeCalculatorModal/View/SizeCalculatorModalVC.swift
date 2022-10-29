//
//  SizeCalculatorModalVC.swift
//  ASHUReusableAsset
//
//  Created by Stephen Giovanni Saputra on 03/10/22.
//

import UIKit
import SnapKit
import Combine

class SizeCalculatorModalVC: UIViewController, UIViewControllerTransitioningDelegate {

    // MARK: - Properties
    private lazy var recommendedSizeLabel: ReusableLabel = {
        let label = ReusableLabel(style: .subHeading_2, textString: "Recommended size")
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var sizeLabel: ReusableLabel = {
        let label = ReusableLabel(style: .heading_1, textString: "")
        label.textAlignment = .right
        return label
    }()
    
    private lazy var recommendedSizeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [recommendedSizeLabel, sizeLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 16
        stack.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width)
            make.height.equalTo(sizeLabel.snp.height)
        }
        return stack
    }()
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return view
    }()
    
    private lazy var brandLabel: ReusableLabel = {
        let label = ReusableLabel(style: .productDetailBrand, textString: "")
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var productNameLabel: ReusableLabel = {
        let label = ReusableLabel(style: .heading_2, textString: "")
        return label
    }()
    
    private lazy var productDetailStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [brandLabel, productNameLabel])
        stack.axis = .vertical
        stack.spacing = 3
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var availableSizeLabel: ReusableLabel = {
        let label = ReusableLabel(style: .bodyText, textString: "Available sizes:")
        label.textColor = .systemGray
        return label
    }()
    
    let sizeStack = UIStackView()
    
    weak var selectedView: SizeButtonView? {
        willSet {
            UIView.animate(withDuration: 0.15) {
                // set unselected state
                self.selectedView?.backgroundColor = UIColor.sizeButtonViewBG
                self.selectedView?.fontColor = .primaryButtonColor!
                
                // set new view to selected state
                newValue?.backgroundColor = .primaryButtonColor!
                newValue?.fontColor = .white
            }
        }
    }
    
    private lazy var mannequinImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "SizeCalculatorBody-Empty"))
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var chestButton: ReusableSizeCalculatorButton = {
        let button = ReusableSizeCalculatorButton(buttomImage: "", selector: #selector(handleChestButton), target: self)
        button.isEnabled = false
        return button
    }()
    
    private lazy var heightButton: ReusableSizeCalculatorButton = {
        let button = ReusableSizeCalculatorButton(buttomImage: "", selector: #selector(handleHeightButton), target: self)
        button.isEnabled = false
        return button
    }()
    
    private lazy var waistButton: ReusableSizeCalculatorButton = {
        let button = ReusableSizeCalculatorButton(buttomImage: "", selector: #selector(handleWaistButton), target: self)
        button.isEnabled = false
        return button
    }()
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?

    let modalType = "Tappable"
    var modalSize = 1.24
    
    var productSizeChart: [ProductSizeChart]?
    var brandName: String
    var productName: String
    
    let profileVM = ProfileViewModel(service: Service())
    var user: User!
    private var cancellables: Set<AnyCancellable> = []
    
    let sizeCalcVM = SizeCalcViewModel()
    
    var chestButtonCurrentSize = 0
    var heightButtonCurrentSize = 0
    var waistButtonCurrentSize = 0
    
    init(productSizeChart: [ProductSizeChart], brandName: String, productName: String) {
        self.productSizeChart = productSizeChart
        self.brandName = brandName
        self.productName = productName
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        profileVM.user.sink { user in
            self.user = user
            self.sizeLabel.text = self.sizeCalcVM.recommendationSize(
                chestUser: user.userBodyMeasurement["Chest"]!,
                waistUser: user.userBodyMeasurement["Waist"]!,
                heightUser: user.userBodyMeasurement["Height"]!,
                productSizeChart: self.productSizeChart!
            )
            
            self.mannequinImageView.image = UIImage(named: "SizeCalculatorBody-\(user.userGender)")
            self.chestButton.setImage(UIImage(named: "sizeButtonInitial"), for: .normal)
            self.heightButton.setImage(UIImage(named: "sizeButtonInitial"), for: .normal)
            self.waistButton.setImage(UIImage(named: "sizeButtonInitial"), for: .normal)
            
            self.configureSizeButton()
        }.store(in: &cancellables)
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        profileVM.getUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        profileVM.getUser()
    }
    
    override func viewDidLayoutSubviews() {
        
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    // MARK: - Selectors
    @objc func handleDismiss() {
        self.dismiss(animated: true)
    }
    
    @objc func handleChestButton() {
        
        print("DEBUG: \(sizeCalcVM.setChestButtonMessage(currSize: chestButtonCurrentSize))")
    }
    
    @objc func handleHeightButton() {
        
        print("DEBUG: \(sizeCalcVM.setHeightButtonMessage(currSize: chestButtonCurrentSize))")
    }
    
    @objc func handleWaistButton() {
        
        print("DEBUG: \(sizeCalcVM.setWaistButtonMessage(currSize: chestButtonCurrentSize))")
    }
    
    @objc func onViewSelected(_ sender: UITapGestureRecognizer) {
        
        selectedView = sender.view as? SizeButtonView
        
        chestButtonCurrentSize = sender.view?.tag ?? 100
        chestButton.setImage(UIImage(
            named: sizeCalcVM.setChestButtonImage(currSize: chestButtonCurrentSize)),
                             for: .normal)
        chestButton.isEnabled = true
        
        heightButtonCurrentSize = sender.view?.tag ?? 100
        heightButton.setImage(UIImage(
            named: sizeCalcVM.setHeightButtonImage(currSize: heightButtonCurrentSize)),
                              for: .normal)
        heightButton.isEnabled = true
        
        waistButtonCurrentSize = sender.view?.tag ?? 100
        waistButton.setImage(UIImage(
            named: sizeCalcVM.setWaistButtonImage(currSize: waistButtonCurrentSize)),
                             for: .normal)
        waistButton.isEnabled = true
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        
        view.backgroundColor = .backgroundColor
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 44))
        
        // To set custom font for title
        let navItem = UINavigationItem(title: "Size Calculator")
        let navBarAttribute = [NSAttributedString.Key.font: UIFont.modalTitle()]
        UINavigationBar.appearance().titleTextAttributes = navBarAttribute
        
        // To set transparent background for navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        
        // To set Cancel button and custom font
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(handleDismiss))
        let navItemAttribute = [NSAttributedString.Key.font: UIFont.bodyText()]
        UIBarButtonItem.appearance().setTitleTextAttributes(navItemAttribute, for: .normal)
        UIBarButtonItem.appearance().tintColor = .label
        
        // Add Cancel button to the right
        navItem.rightBarButtonItem = cancelItem
        
        // Add all items to the navigation bar
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        view.addSubview(recommendedSizeStack)
        recommendedSizeStack.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(recommendedSizeStack.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        brandLabel.text = brandName
        productNameLabel.text = productName
        view.addSubview(productDetailStack)
        productDetailStack.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        sizeStack.axis = .horizontal
        sizeStack.alignment = .center
        sizeStack.distribution = .fill
        sizeStack.spacing = (view.frame.width - 40) / 43.75
        view.addSubview(sizeStack)
        sizeStack.snp.makeConstraints { make in
            make.height.equalTo(view.frame.height / 18)
            make.top.equalTo(productDetailStack.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        view.addSubview(mannequinImageView)
        mannequinImageView.snp.makeConstraints { make in
            make.top.equalTo(sizeStack.snp.bottom).offset(20)
            make.width.equalTo(view.frame.width)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        
        view.addSubview(chestButton)
        chestButton.snp.makeConstraints { make in
            make.leading.equalTo(mannequinImageView.snp.leading).offset(view.frame.width / 2.03)
            make.top.equalTo(mannequinImageView.snp.top).offset(mannequinImageView.frame.height / 3.76)
            make.width.height.equalTo(view.frame.width / 8.67)
        }
        
        view.addSubview(heightButton)
        heightButton.snp.makeConstraints { make in
            make.leading.equalTo(mannequinImageView.snp.leading).offset(view.frame.width / 13)
            make.top.equalTo(mannequinImageView.snp.top).offset(mannequinImageView.frame.height / 2.5)
            make.width.height.equalTo(view.frame.width / 8.67)
        }
        
        view.addSubview(waistButton)
        waistButton.snp.makeConstraints { make in
            make.leading.equalTo(mannequinImageView.snp.leading).offset(view.frame.width / 2.03)
            make.top.equalTo(mannequinImageView.snp.top).offset(mannequinImageView.frame.height / 2)
            make.width.height.equalTo(view.frame.width / 8.67)
        }
    }
    
    func configureSizeButton() {
        
        let views = sizeCalcVM.setupSizeButton()
        
        views.forEach {
            
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(onViewSelected(_:))
            )
            
            $0.addGestureRecognizer(tapGesture)
            
            tapGesture.view?.tag = $0.sizeInt
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(view.frame.height / 18)
                make.width.equalTo(view.frame.width / 6.2)
            }
            
            $0.layer.cornerRadius = 10
            sizeStack.addArrangedSubview($0)
        }
    }
}
