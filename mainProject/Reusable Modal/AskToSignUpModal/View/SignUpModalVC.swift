//
//  SignUpModalVC.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 01/10/22.
//

import UIKit
import SnapKit

class SignUpModalVC: UIViewController {
    
    // MARK: - Properties
    private lazy var heading: ReusableLabel = {
        let label = ReusableLabel(style: .heading_1, textString: "Before that, do you want to sign up?")
        return label
    }()
    
    private lazy var subheading: ReusableLabel = {
        let label = ReusableLabel(style: .subHeading_2, textString: "Creating an account allows you to access all of our features")
        return label
    }()
    
    private lazy var signUpButton: ReusableButton = {
        let button = ReusableButton(style: .primary, buttonText: "Sign Up", selector: #selector(handleDismiss), target: self)
        return button
    }()
    
    private lazy var skipButton: ReusableButton = {
        let button = ReusableButton(style: .secondary, buttonText: "Skip", selector: #selector(handleDismiss), target: self)
        return button
    }()
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    let modalSize = 2.24
    let modalType = "NotTappable"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    // MARK: - Selectors
    @objc func handleDismiss() {
        print("BYE FELICIA")
        self.dismiss(animated: true)
    }
    
    // MARK: - Helpers
    func configureUI() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(heading)
        heading.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(subheading)
        subheading.snp.makeConstraints { make in
            make.top.equalTo(heading.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        let stack = UIStackView(arrangedSubviews: [signUpButton, skipButton])
        stack.spacing = 8
        stack.alignment = .center
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-23)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
