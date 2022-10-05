//
//  SignUpViewController.swift
//  mainProject
//
//  Created by Bryan Kenneth on 04/10/22.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: - Properties
    private lazy var bgLogin: UIImageView = {
        let imageView = AuthBackground()
        return imageView
    }()
    
    private lazy var pinkTitle: UIStackView = {
        let sview = ReusableCapsuleTitle(title: "Create Your Account")
        sview.spacing = view.frame.height * 0.019
        return sview
    }()
    
    private lazy var emailTextField: TextField = {
        let textField = TextField()
        textField.backgroundColor = UIColor.lightGray
        textField.attributedPlaceholder = NSAttributedString(string: "Email")
        textField.layer.cornerRadius = 15
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.redColor.cgColor
        return textField
    }()
    
    private lazy var emailError: ReusableLabel = {
        let error = ReusableLabel(style: .caption, textString: "Email not registered")
        error.textColor = .redColor
        return error
    }()
    
    
    
    private lazy var passwordTextField: TextField = {
        let textField = TextField()
        textField.backgroundColor = UIColor.lightGray
        textField.attributedPlaceholder = NSAttributedString(string: "Password")
        textField.layer.cornerRadius = 15
        
        return textField
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    
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
            make.top.equalToSuperview().offset(view.frame.height * 0.195)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(pinkTitle.snp.bottom).offset(view.frame.height*0.0569)
            make.height.equalTo(view.frame.height*0.055)
        }
        
        view.addSubview(emailError)
        emailError.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(emailTextField.snp.bottom).offset(view.frame.height*0.0047)
        }
        
        
        
    }

}
