//
//  SignUpViewController.swift
//  mainProject
//
//  Created by Bryan Kenneth on 04/10/22.
//

import UIKit
import UIWindowTransitions
import SnapKit

class SignUpViewController: UIViewController {

    // MARK: - Properties
    private var showPassword = false
    private var showConfirmPassword = false
    private var error1Complete = false
    private var error2Complete = false
    
    private lazy var bgLogin: UIImageView = {
        let imageView = AuthBackground()
        return imageView
    }()
    
    private lazy var pinkTitle: UIStackView = {
        let sview = ReusableCapsuleTitle(title: "Create your\naccount")
        sview.spacing = view.frame.height * 0.019
        return sview
    }()
    
    private lazy var emailTextField: TextField = {
        let textField = ReusableTextFieldAuth(placeholders: "Email")
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var emailError: ReusableLabel = {
        let error = ReusableLabel(style: .caption, textString: "Email has been registered")
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
    
    private lazy var signUpButton: ReusableButton = {
        let reusableBtn = ReusableButton(style: .primaryDisabled, buttonText: "Sign Up", selector: #selector(handleSignUp), target: self)
        reusableBtn.makeDisabled(isDisabled: true)
        return reusableBtn
    }()
    
    @objc func handleSignUp(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        AuthServices.shared.registerWithEmail(email: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                if error.localizedDescription ==  "The email address is already in use by another account." {
                    self.emailError.isHidden = false
                }
            }
            
            if let user = result?.user {
                let userInfo: [String: Any] = [
                    "name" : "",
                    "email" : user.email,
                    "uid": user.uid,
                    "gender": ""
                ]
                
                AuthServices.shared.writeUserData(credentials: userInfo) {
                    let wnd = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                    var options = UIWindow.TransitionOptions()
                    options.direction = .toRight
                    options.duration = 0.4
                    options.style = .easeIn
                    
                    wnd?.set(rootViewController: PersonalizeViewController(), options: options)
                }
            }
        }
        
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        passwordTextField.delegate = self
        emailTextField.delegate = self
        confirmPasswordTextField.delegate = self
        configureUI()
        
        passwordTextField.addTarget(self, action: #selector(self.passwordTextFieldDidChange(_:)),
                                      for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                      for: .editingChanged)
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if passwordTextField.text != confirmPasswordTextField.text {
            passwordNotMatch.isHidden = false
            error2Complete = false
        } else {
            passwordNotMatch.isHidden = true
            error2Complete = true
        }
        disableButton()
    }
    
    @objc func passwordTextFieldDidChange(_ textField: UITextField) {
        if passwordTextField.text!.count >= 6 {
            passwordError.updateImage(newImage: "checkmark.circle", success: true)
            passwordError.tintColor = .greenColor
            error1Complete = true
        } else {
            passwordError.updateImage(newImage: "circle", success: false)
            passwordError.tintColor = .redColor
            error1Complete = false
        }
        
        let numbersRange = passwordTextField.text!.rangeOfCharacter(from: .decimalDigits)
        let hasNumbers = (numbersRange != nil)
        
        if hasNumbers {
            passwordError2.updateImage(newImage: "checkmark.circle", success: true)
            error1Complete = true
        } else {
            passwordError2.updateImage(newImage: "circle", success: false)
            error1Complete = false
        }
        
        if confirmPasswordTextField.text != "" || confirmPasswordTextField.text != nil{
            if passwordTextField.text != confirmPasswordTextField.text {
                passwordNotMatch.isHidden = false
                error2Complete = false
            } else {
                passwordNotMatch.isHidden = true
                error2Complete = true
            }
        }
        disableButton()
    }
    
    // MARK: - Helpers
    func configureUI() {
        
        view.backgroundColor = .backgroundColor
        
        navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        
        view.addSubview(bgLogin)
        bgLogin.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        emailError.isHidden = true
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(emailError.snp.bottom).offset(view.frame.height*0.01421800948)
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
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-view.frame.height * 0.1220379147)
        }
        
    }
    
    func disableButton(){
        if error1Complete && error2Complete {
            signUpButton.makeDisabled(isDisabled: false)
        } else {
            signUpButton.makeDisabled(isDisabled: true)
        }
    }

}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
