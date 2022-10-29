//
//  ResetPasswordViewController.swift
//  mainProject
//
//  Created by Bryan Kenneth on 06/10/22.
//

import UIKit
import SnapKit

class ResetPasswordViewController: UIViewController {

    // MARK: - Properties
    private var showPassword = false
    private var showConfirmPassword = false
    private var showOldPassword = false
    
    private var error1Complete = false
    private var error2Complete = false
    
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "brand-catalogue")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var oldPasswordTextField: ReusablePasswordTextField = {
        let textField = ReusablePasswordTextField(placeholderss: "Old Password", selector: #selector(fieldShowPassword), target: self)
        return textField
    }()
    private lazy var oldPasswordError: ReusableLabel = {
        let error = ReusableLabel(style: .caption, textString: "Old password is not correct")
        error.textColor = .redColor
        return error
    }()
    
    private lazy var passwordTextField: ReusablePasswordTextField = {
        let textField = ReusablePasswordTextField(placeholderss: "Password", selector: #selector(fieldShowPassword), target: self)
        return textField
    }()
    
    private lazy var confirmPasswordTextField: ReusablePasswordTextField = {
        let confirmTextField = ReusablePasswordTextField(placeholderss: "Confirm Password", selector: #selector(fieldShowConfirmPassword), target: self)
        return confirmTextField
    }()
    
    private lazy var passwordError: ReusableErrorLabel = {
        let errorView = ReusableErrorLabel(text: "must be 6 characters long")
        return errorView
    }()
    
    private lazy var passwordError2: ReusableErrorLabel = {
       let errorView = ReusableErrorLabel(text: "must include combination of numbers & letters")
        return errorView
    }()
    
    
    private lazy var passwordNotMatch: ReusableLabel = {
        let errorLabel = ReusableLabel(style: .caption, textString: "Password not match")
        errorLabel.textColor = .redColor
        return errorLabel
    }()
    
    private lazy var savePassword: ReusableButton = {
        let reusableBtn = ReusableButton(style: .primaryDisabled, buttonText: "Save Password", selector: #selector(handleSavePassword), target: self)
    
        return reusableBtn
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func fieldShowOldPassword(){
        if !showOldPassword {
            oldPasswordTextField.isSecureTextEntry = false
            oldPasswordTextField.updateImage(newImage: "eye.slash")
            showOldPassword = true
        } else {
            oldPasswordTextField.isSecureTextEntry = true
            oldPasswordTextField.updateImage(newImage: "eye")
            showOldPassword = false
        }
        
    }
    
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
    
    @objc func fieldShowConfirmPassword(){
        if !showConfirmPassword {
            confirmPasswordTextField.isSecureTextEntry = false
            confirmPasswordTextField.updateImage(newImage: "eye.slash")
            showConfirmPassword = true
        } else {
            confirmPasswordTextField.isSecureTextEntry = true
            confirmPasswordTextField.updateImage(newImage: "eye")
            showConfirmPassword = false
        }
    }
    
    @objc func handleSavePassword(){
        
    }
    
    @objc func handleCancel() {
        print("Cancel")
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    func configureUI() {
        
        view.backgroundColor = .backgroundColor
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.heading_1()
        ]
        
        self.title = "Reset Password"
        self.navigationController?.title = "Reset Password"
        
        let leftBarBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        let navItemAttribute = [
            NSAttributedString.Key.font: UIFont.bodyText()
        ]
        leftBarBtn.setTitleTextAttributes(navItemAttribute, for: .normal)
        leftBarBtn.tintColor = .whiteColor
        navigationItem.leftBarButtonItem = leftBarBtn
        
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(oldPasswordTextField)
        oldPasswordTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(36)
            make.height.equalTo(view.frame.height*0.055)
        }
        
        view.addSubview(oldPasswordError)
        oldPasswordError.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(oldPasswordTextField.snp.bottom).offset(view.frame.height * 0.004739336493)
        }
        oldPasswordError.isHidden = true
        
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(oldPasswordError.snp.bottom).offset(view.frame.height*0.01421800948 + 12)
            make.height.equalTo(view.frame.height*0.055)
        }
        
        view.addSubview(passwordError)
        passwordError.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(passwordTextField.snp.bottom).offset(view.frame.height*0.0047)
        }
        
        view.addSubview(passwordError2)
        passwordError2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(passwordError.snp.bottom).offset(view.frame.height * 0.02725118483)
        }
        
        view.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(passwordError2.snp.bottom).offset(48)
            make.height.equalTo(view.frame.height*0.055)
        }
        
        view.addSubview(passwordNotMatch)
        passwordNotMatch.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(view.frame.height * 0.004739336493)
        }
        passwordNotMatch.isHidden = true
        
        view.addSubview(savePassword)
        savePassword.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-view.frame.height * 0.1469194313)
        }
        
      
    }

}
