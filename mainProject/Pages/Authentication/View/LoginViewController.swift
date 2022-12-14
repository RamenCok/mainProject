//
//  LoginViewController.swift
//  mainProject
//
//  Created by Bryan Kenneth on 06/10/22.
//

import UIKit
import SnapKit
import UIWindowTransitions

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
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var emailError: ReusableLabel = {
        let error = ReusableLabel(style: .caption, textString: "Email not registered")
        error.textColor = .redColor
        return error
    }()
    
    private lazy var passwordError: ReusableLabel = {
        let errorLabel = ReusableLabel(style: .caption, textString: "Incorrect Password")
        errorLabel.textColor = .redColor
        return errorLabel
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
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        AuthServices.shared.loginWithEmail(email: email, password: password) { AuthDataResult, error in
            if let error = error {
                if error.localizedDescription == "The password is invalid or the user does not have a password." {
                    self.passwordError.isHidden = false
                    self.emailError.isHidden = true
                } else if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                    self.emailError.isHidden = false
                    self.passwordError.isHidden = true
                } else {
                    let alert = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            } else {
                let alert = UIAlertController(title: "Login Succcessful", message: "You'll be redirected shortly", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "You'll be redirected shortly", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                let wnd = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                var options = UIWindow.TransitionOptions()
                options.direction = .toRight
                options.duration = 0.4
                options.style = .easeIn
                if let users = AuthDataResult?.user {
                    print("Nice you're now signed in as \(users.uid), email: \(users.email ?? "unknown email")")
                    
                    let user: [String: Any] = [
                        "name" : users.displayName == nil ? users.email : users.displayName,
                        "email" : users.email,
                        "uid": users.uid,
                        "gender": ""
                    ]
                    AuthServices.shared.checkUserData(uid: user["uid"] as! String) { document, error in
                        if let document = document, document.exists {
                            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                            
                            if document.data()!["gender"] == nil || document.data()!["gender"] as! String == "" {
                                wnd?.set(rootViewController: UINavigationController(rootViewController:  BrandCatalogueViewController()) , options: options)
                            } else {
                                wnd?.set(rootViewController: UINavigationController(rootViewController:  BrandCatalogueViewController()), options: options)
                            }
                            print("Document data: \(dataDescription)")
                        } else {
                            AuthServices.shared.writeUserData(credentials: user) {
                                wnd?.set(rootViewController: UINavigationController(rootViewController:  BrandCatalogueViewController()), options: options)
                            }
                        }
                    }
            }
            
            
            }
            
        }
    }
        // MARK: - Helpers
        func configureUI() {
            
            view.backgroundColor = .backgroundColor
            
            navigationController?.isNavigationBarHidden = false
            navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
            
            view.addSubview(bgLogin)
            bgLogin.snp.makeConstraints { make in
                make.edges.equalToSuperview()
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
    
            passwordError.isHidden = true
            
            view.addSubview(signUpButton)
            signUpButton.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.bottom.equalToSuperview().offset(-view.frame.height * 0.1469194313)
            }
        }
        
   
}
