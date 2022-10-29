//
//  BuyModalVC.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 01/10/22.
//

import UIKit
import SnapKit

class BuyModalVC: UIViewController {

    // MARK: - Properties
    
    
    // MAKE THIS REUSABLE LIKE COLOR RADIO BUTTON DI PRODUCT DETAIL VIEW
    private lazy var button1: ReusableButton = {
        let button = ReusableButton(style: .secondary, buttonText: "Tokopedia", selector: #selector(handleDismiss), target: self)
        return button
    }()
    
    private lazy var button2: ReusableButton = {
        let button = ReusableButton(style: .secondary, buttonText: "Tokopedia", selector: #selector(handleDismiss), target: self)
        return button
    }()
    
    private lazy var button3: ReusableButton = {
        let button = ReusableButton(style: .secondary, buttonText: "Tokopedia", selector: #selector(handleDismiss), target: self)
        return button
    }()
    
    private lazy var button4: ReusableButton = {
        let button = ReusableButton(style: .secondary, buttonText: "Tokopedia", selector: #selector(handleDismiss), target: self)
        return button
    }()
    
    private lazy var button5: ReusableButton = {
        let button = ReusableButton(style: .secondary, buttonText: "Tokopedia", selector: #selector(handleDismiss), target: self)
        return button
    }()
    
    public lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [button1, button5, button4, button2])
        return stack
    }()
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    let modalType = "Tappable"
    
    let vm = BuyModalVM()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(stack.subviews.count)
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
        
        print(stack.frame.height)
    }
    
    // MARK: - Selectors
    @objc func handleDismiss() {
        print("BYE FELICIA")
        self.dismiss(animated: true)
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
        let navItem = UINavigationItem(title: "Buy")
        let navBarAttribute = [NSAttributedString.Key.font: UIFont.modalTitle()]
        UINavigationBar.appearance().titleTextAttributes = navBarAttribute
        
        // To set transparent background for navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        
        // To set Cancel button and custom font
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(handleDismiss))
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
        
        stack.spacing = 10
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalCentering
        
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
