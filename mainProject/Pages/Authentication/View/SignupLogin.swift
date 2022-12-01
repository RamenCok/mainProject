//
//  SignupLogin.swift
//  mainProject
//
//  Created by Bryan Kenneth on 04/10/22.
//

import UIKit
import SnapKit
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import AuthenticationServices
import UIWindowTransitions
import CryptoKit

class SignupLogin: UIViewController {
    
    // MARK: - Properties
    fileprivate var currentNonce: String?
    
    private lazy var bgLogin: UIImageView = {
        let imageView = AuthBackground()
        return imageView
    }()
    
    private lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.addSubview(titleLabel)
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(style: .largeTitle_2, textString: "Level up your\nshopping journey")
        return label
    }()
    
    private lazy var pinkCapsule: UIView = {
        let view = ResuablePinkCapsule()
        return view
    }()
    
    private lazy var appleBtn: ReusableButton = {
        let button = ReusableButton(style: .secondary, buttonText: " Continue with Apple", selector: #selector(handleAppleLogin), target: self)
        button.setImage(UIImage(systemName: "apple.logo"), for: .normal)
        button.tintColor = .primaryColor
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        return button
    }()
    
    private lazy var appleBtn2: ASAuthorizationAppleIDButton = {
        let authorizationButton = ASAuthorizationAppleIDButton()
          authorizationButton.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
          authorizationButton.cornerRadius = 10
        return authorizationButton
    }()
    
    private lazy var googleBtn: UIButton = {
        let button = ReusableButton(style: .secondary, buttonText: " Continue with Google", selector: #selector(handleGoogleLogIn), target: self)
        button.setImage(UIImage(named: "google.logo"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
//            make.width.equalTo(20)
        }
        return view
    }()
    private lazy var divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
//            make.width.equalTo(20)
        }
        return view
    }()
    
    private lazy var orLabel: UILabel = {
        let label = ReusableLabel(style: .bodyText, textString: "or")
        label.snp.makeConstraints { make in
//            make.width.equalTo(16)
        }
        return label
    }()
    
    private lazy var loginBtn: UIButton = {
        let button = ReusableButton(style: .primary, buttonText: "Log In", selector: #selector(handleLogin), target: self)
        return button
    }()
    
    private lazy var attributedBtn: UIButton = {
        let btn = UIButton()
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blackTexts, NSAttributedString.Key.font: UIFont(name: "Sora-Regular", size: 15)!])
        
        attributedTitle.append(NSAttributedString(string: " Sign Up", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blackTexts, NSAttributedString.Key.font: UIFont(name: "Sora-SemiBold", size: 15)!, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]))
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
        return btn
    }()
    
    private lazy var stackView: ReusableCapsuleTitle = {
        let stackView = ReusableCapsuleTitle(title: "Level up your shopping journey")
        stackView.spacing = view.frame.height * 0.019
        return stackView
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleGoogleLogIn(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) {[unowned self] user, error in
            
          if let error = error {
              print(error.localizedDescription)
          }

          guard let authentication = user?.authentication, let idToken = authentication.idToken else {return}

          let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential) { authResult, error in
                print(authResult?.user.providerData)
                
                if let error = error {
                    let alert = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Login Succcessful", message: "You'll be redirected shortly", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    
                    // User is signed in
                    let user: [String: Any] = [
                        "name" : authResult?.user.displayName,
                        "email" : authResult?.user.email,
                        "uid": authResult?.user.uid,
                        "gender": "Male"
                    ]
                    
                    let wnd = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                    var options = UIWindow.TransitionOptions()
                    options.direction = .toRight
                    options.duration = 0.4
                    options.style = .easeIn
                    
                    AuthServices.shared.checkUserData(uid: user["uid"] as! String) { document, error in
                        if let document = document, document.exists {
                              let dataDescription = document.data().map(String.init(describing:)) ?? "nil"

                            if document.data()!["name"] as! String == "" {
                                wnd?.set(rootViewController: UINavigationController(rootViewController: BrandCatalogueViewController()), options: options)
                            } else {
                                wnd?.set(rootViewController: UINavigationController(rootViewController: BrandCatalogueViewController()), options: options)
                            }
                              print("Document data: \(dataDescription)")
                        } else {
                            AuthServices.shared.writeUserData(credentials: user) {
                                print(user)
                                print("Yow")
                                wnd?.set(rootViewController: UINavigationController(rootViewController: BrandCatalogueViewController()), options: options)
                            }
                        }
                   
                    }
                }
            }
        }
    }
    
    @objc func handleAppleLogin(){
        let request = createAppleIDRequest()
        let authorizationcontroller = ASAuthorizationController(authorizationRequests: [request])
        authorizationcontroller.delegate = self
        authorizationcontroller.presentationContextProvider = self
        
        authorizationcontroller.performRequests()
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = AuthServices.shared.randomNonceString()
        request.nonce = AuthServices.shared.sha256(nonce)
        currentNonce = nonce
        return request
    }
    
    @objc func handleCancelButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goToSignUp() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    @objc func handleLogin() {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    // MARK: - Helpers
    func configureUI() {
     
        view.backgroundColor = .backgroundColor
        
        // To set transparent background for navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        
        let leftBarBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButton))
        let navItemAttribute = [
            NSAttributedString.Key.font: UIFont.bodyText()
        ]
        leftBarBtn.setTitleTextAttributes(navItemAttribute, for: .normal)
        leftBarBtn.tintColor = .primaryColor
        navigationItem.leftBarButtonItem = leftBarBtn
        navigationController?.navigationBar.tintColor = .primaryColor
        
        view.addSubview(bgLogin)
        bgLogin.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(view.frame.height * 0.32)
        }
        
        appleBtn.setImage(UIImage(systemName: "apple.logo"), for: .normal)
        let stackViewBtn = UIStackView(arrangedSubviews: [appleBtn2, googleBtn])
        stackViewBtn.axis = .vertical
        stackViewBtn.alignment = .leading
        stackViewBtn.spacing = view.frame.height * 0.0095

        
        view.addSubview(stackViewBtn)
        stackViewBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(20)
            make.top.equalTo(stackView.snp.bottom).offset(view.frame.height*0.0569)
        }
        
        appleBtn2.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(UIScreen.main.bounds.width - 40)
        }
        let viewOr = UIView()
        viewOr.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.leading.equalTo(viewOr.snp.leading)
            make.width.equalTo(view.frame.width * 0.38)
        }
        viewOr.addSubview(orLabel)
        orLabel.snp.makeConstraints { make in
            make.leading.equalTo(divider.snp.trailing).offset(view.frame.width * 0.038)
            make.centerY.equalTo(viewOr.snp.centerY)
        }
        viewOr.addSubview(divider2)
        divider2.snp.makeConstraints { make in
            make.leading.equalTo(orLabel.snp.trailing).offset(view.frame.width * 0.038)
            make.trailing.equalTo(viewOr.snp.trailing)
            make.centerY.equalTo(viewOr.snp.centerY)
        }
        
        view.addSubview(viewOr)
        viewOr.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(stackViewBtn.snp.bottom).offset(view.frame.height*0.027)
        }
        
        
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(viewOr.snp.bottom).offset(view.frame.height*0.027)
        }

        view.addSubview(attributedBtn)
        attributedBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(loginBtn.snp.bottom).offset(view.frame.height * 0.014)
        }

    }

}


extension SignupLogin: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("Complete authorization")
            guard currentNonce != nil else {
                fatalError("Invalid state: A login callback was received, but no login request was sent")
            }
            guard let appleIDtoken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDtoken, encoding: .utf8) else {
                print("Unable to fetch idTokenString")
                return
            }
            
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: currentNonce)
            print("Email")
            Auth.auth().signIn(with: credential) { (AuthDataResult, error) in
                if let error = error {
                    let alert = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Login Succcessful", message: "You'll be redirected shortly", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "You'll be redirected shortly", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                let wnd = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                var options = UIWindow.TransitionOptions()
                options.direction = .toRight
                options.duration = 0.4
                options.style = .easeIn
                if let users = AuthDataResult?.user {
                    print("Nice you're now signed in as \(users.uid), email: \(users.email ?? "unknown email")")
                    print(appleIDCredential.fullName)
                    print("email: \(appleIDCredential.email)")
                    let user: [String: Any] = [
                        "name" : appleIDCredential.fullName?.givenName == nil ? users.email : appleIDCredential.fullName?.givenName,
                        "email" : users.email,
                        "uid": users.uid,
                        "gender": "Male"
                    ]
                    
                    print("debug name: \(users.displayName)")
                    AuthServices.shared.checkUserData(uid: user["uid"] as! String) { document, error in
                        if let document = document, document.exists {
                            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"

                            if document.data()!["name"] as! String == "" {
                                wnd?.set(rootViewController: UINavigationController(rootViewController: BrandCatalogueViewController()) , options: options)
                            } else {
                                wnd?.set(rootViewController: UINavigationController(rootViewController: BrandCatalogueViewController()), options: options)
                            }
                            print("Document data: \(dataDescription)")
                        } else {
                            if user["name"] as! String == "" {
                                AuthServices.shared.writeUserData(credentials: user) {
                                    wnd?.set(rootViewController: UINavigationController(rootViewController: BrandCatalogueViewController()), options: options)
                                }
                            } else {
                                AuthServices.shared.writeUserData(credentials: user) {
                                    wnd?.set(rootViewController: UINavigationController(rootViewController: BrandCatalogueViewController()), options: options)
                                }
                            }
                        }
                    }
                    
                    
                }
            }
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
