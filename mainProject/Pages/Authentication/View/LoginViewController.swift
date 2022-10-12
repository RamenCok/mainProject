//
//  LoginViewController.swift
//  mainProject
//
//  Created by Bryan Kenneth on 06/10/22.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    private var showPassword = false
    // MARK: - Properties
    private lazy var bgLogin: UIImageView = {
        let imageView = AuthBackground()
        return imageView
    }()
    
    private lazy var pinkTitle: UIStackView = {
        let sview = ReusableCapsuleTitle(title: "Login to your\naccount")
        sview.spacing = view.frame.height * 0.019
        return sview
    }()
    
    private lazy var emailTextField: TextField = {
        let textField = ReusableTextFieldAuth(placeholders: "Email")
        return textField
    }()
    
    private lazy var emailError: ReusableLabel = {
        let error = ReusableLabel(style: .caption, textString: "Email not registered")
        error.textColor = .redColor
        return error
    }()
    
    private lazy var passwordTextField: ReusablePasswordTextField = {
        let textField = ReusablePasswordTextField(placeholderss: "Password", selector: #selector(fieldShowPassword), target: self)
        return textField
    }()
    
    private lazy var signUpButton: ReusableButton = {
        let reusableBtn = ReusableButton(style: .primary, buttonText: "Log In", selector: #selector(handleLogin), target: self)
//        reusableBtn.makeDisabled(isDisabled: true)
        return reusableBtn
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func fieldShowPassword(){
        if !showPassword {
            passwordTextField.isSecureTextEntry = false
            passwordTextField.updateImage(newImage: "eye.slash")
            showPassword = true
        } else {
            passwordTextField.isSecureTextEntry = true
            passwordTextField.updateImage(newImage: "eye")
            showPassword = false
        }
    }
    
    @objc func handleLogin(){
        
        let vc = BrandCatalogueViewController()
        let navController = UINavigationController(rootViewController: vc)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .coverVertical
        self.present(navController, animated: true)
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(bgLogin)
        bgLogin.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        view.addSubview(pinkTitle)
        pinkTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(view.frame.height * 0.3317535545)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(pinkTitle.snp.bottom).offset(view.frame.height*0.0569)
            make.height.equalTo(view.frame.height*0.055)
        }
        
        
//        view.addSubview(emailError)
//        emailError.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().offset(-20)
//            make.top.equalTo(emailTextField.snp.bottom).offset(view.frame.height*0.0047)
//        }
//
//        emailError.isHidden = true
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(emailTextField.snp.bottom).offset(view.frame.height*0.01421800948)
            make.height.equalTo(view.frame.height*0.055)
        }
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-view.frame.height * 0.1469194313)
        }
    }

}
