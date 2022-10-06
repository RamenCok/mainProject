//
//  SizeCalculatorModalVC.swift
//  ASHUReusableAsset
//
//  Created by Stephen Giovanni Saputra on 03/10/22.
//

import UIKit
import SnapKit

class SizeCalculatorModalVC: UIViewController, UIViewControllerTransitioningDelegate {

    // MARK: - Properties
    private lazy var recommendedSizeLabel: ReusableLabel = {
        let label = ReusableLabel(style: .subHeading_2, textString: "Recommended size")
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var sizeLabel: ReusableLabel = {
        let label = ReusableLabel(style: .heading_1, textString: "M")
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
        view.backgroundColor = .lightGray
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return view
    }()
    
    private lazy var brandLabel: ReusableLabel = {
        let label = ReusableLabel(style: .productDetailBrand, textString: "Love, Bonito")
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var productNameLabel: ReusableLabel = {
        let label = ReusableLabel(style: .heading_2, textString: "Lela Textured A-line Dress")
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
    
    let xsSizeView = SizeButtonView(sizeName: "XS")
    let sSizeView = SizeButtonView(sizeName: "S")
    let mSizeView = SizeButtonView(sizeName: "M")
    let lSizeView = SizeButtonView(sizeName: "L")
    let xlSizeView = SizeButtonView(sizeName: "XL")
    
    weak var selectedView: SizeButtonView? {
        willSet {
            UIView.animate(withDuration: 0.15) {
                // set unselected state
                self.selectedView?.backgroundColor = UIColor.systemGray3
                self.selectedView?.fontColor = .primaryColor
                
                // set new view to selected state
                newValue?.backgroundColor = .primaryColor
                newValue?.fontColor = .white
            }
        }
    }
    
    private lazy var sizeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [xsSizeView, sSizeView, mSizeView, lSizeView, xlSizeView])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = (view.frame.width - 40) / 43.75
        stack.snp.makeConstraints { make in
            make.height.equalTo(xsSizeView.snp.height)
        }
        return stack
    }()
    
    private lazy var viewStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [recommendedSizeStack, divider, productDetailStack, sizeStack])
        stack.alignment = .leading
        stack.spacing = 20
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var mannequinImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "SizeCalculatorBody-Woman"))
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var button: ReusableSizeCalculatorButton = {
        let button = ReusableSizeCalculatorButton(buttomImage: "greenExclamation", selector: #selector(handleButton), target: self)
        return button
    }()
    
    private lazy var button2: ReusableSizeCalculatorButton = {
        let button = ReusableSizeCalculatorButton(buttomImage: "greenExclamation", selector: #selector(handleButton), target: self)
        return button
    }()
    
    private lazy var button3: ReusableSizeCalculatorButton = {
        let button = ReusableSizeCalculatorButton(buttomImage: "greenExclamation", selector: #selector(handleButton), target: self)
        return button
    }()
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?

    let modalType = "Tappable"
    var modalSize = 1.24
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
        configureSizeButton()
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
    @objc func handleButton() {
        print("Test")
    }
    
    @objc func onViewSelected(_ sender: UITapGestureRecognizer) {
        selectedView = sender.view as? SizeButtonView
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
        
        view.backgroundColor = .systemBackground
        
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
        
        view.addSubview(productDetailStack)
        productDetailStack.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(sizeStack)
        sizeStack.snp.makeConstraints { make in
            make.top.equalTo(productDetailStack.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(mannequinImageView)
        mannequinImageView.snp.makeConstraints { make in
            make.top.equalTo(sizeStack.snp.bottom).offset(20)
            make.width.equalTo(view.frame.width)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.leading.equalTo(mannequinImageView.snp.leading).offset(view.frame.width / 2.03)
            make.top.equalTo(mannequinImageView.snp.top).offset(mannequinImageView.frame.height / 3.76)
            make.width.height.equalTo(view.frame.width / 8.67)
        }
        
        view.addSubview(button2)
        button2.snp.makeConstraints { make in
            make.leading.equalTo(mannequinImageView.snp.leading).offset(view.frame.width / 13)
            make.top.equalTo(mannequinImageView.snp.top).offset(mannequinImageView.frame.height / 2.71)
            make.width.height.equalTo(view.frame.width / 8.67)
        }
        
        view.addSubview(button3)
        button3.snp.makeConstraints { make in
            make.leading.equalTo(mannequinImageView.snp.leading).offset(view.frame.width / 2.03)
            make.top.equalTo(mannequinImageView.snp.top).offset(mannequinImageView.frame.height / 2.15)
            make.width.height.equalTo(view.frame.width / 8.67)
        }
    }
    
    func configureSizeButton() {
        
        let views = [xsSizeView, sSizeView, mSizeView, lSizeView, xlSizeView]
        views.forEach {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onViewSelected(_:)))
            $0.addGestureRecognizer(tapGesture)
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(view.frame.height / 21.1)
                make.width.equalTo(view.frame.width / 6.2)
            }
            
            $0.layer.cornerRadius = 10
        }
        
        selectedView = mSizeView
    }
}
