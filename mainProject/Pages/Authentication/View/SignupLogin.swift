//
//  SignupLogin.swift
//  mainProject
//
//  Created by Bryan Kenneth on 04/10/22.
//

import UIKit
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
        let label = ReusableLabel(style: .largeTitle_2, textString: "Level up your shopping journey")
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
                    print(error.localizedDescription)
                    return
                }
                
                // User is signed in
                let user: [String: Any] = [
                    "name" : authResult?.user.displayName,
                    "email" : authResult?.user.email,
                    "uid": authResult?.user.uid,
                    "gender": ""
                ]
                
                let wnd = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                var options = UIWindow.TransitionOptions()
                options.direction = .toRight
                options.duration = 0.4
                options.style = .easeIn
                
                AuthServices.shared.checkUserData(uid: user["uid"] as! String) { document, error in
                    if let document = document, document.exists {
                          let dataDescription = document.data().map(String.init(describing:)) ?? "nil"

                        if document.data()!["gender"] == nil || document.data()!["gender"] as! String == "" {
                            wnd?.set(rootViewController: PersonalizeViewController(), options: options)
                        } else {
                            wnd?.set(rootViewController: ProfileViewController(), options: options)
                        }
                          print("Document data: \(dataDescription)")
                    } else {
                        AuthServices.shared.writeUserData(credentials: user) {
                            wnd?.set(rootViewController: ProfileViewController(), options: options)
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
    
    @objc func printYeuy(){
        print("")
    }
    
    @objc func goToSignUp(){
        print("goToSignUp")
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    @objc func handleLogin(){
        navigationController?.pushViewController(LoginViewController(), animated: true)
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

        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(view.frame.height * 0.32)
        }
        
        appleBtn.setImage(UIImage(systemName: "apple.logo"), for: .normal)
        let stackViewBtn = UIStackView(arrangedSubviews: [appleBtn, googleBtn])
        stackViewBtn.axis = .vertical
        stackViewBtn.alignment = .leading
        stackViewBtn.spacing = view.frame.height * 0.0095
        
    
        
        view.addSubview(stackViewBtn)
        stackViewBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(20)
            make.top.equalTo(stackView.snp.bottom).offset(view.frame.height*0.0569)
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
                let wnd = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                var options = UIWindow.TransitionOptions()
                options.direction = .toRight
                options.duration = 0.4
                options.style = .easeIn
                if let user = AuthDataResult?.user {
                    print("Nice you're now signed in as \(user.uid), email: \(user.email ?? "unknown email")")
                    
                    let user: [String: Any] = [
                        "name" : user.displayName,
                        "email" : user.email,
                        "uid": user.uid,
                        "gender": ""
                    ]
                    AuthServices.shared.checkUserData(uid: user["uid"] as! String) { document, error in
                        if let document = document, document.exists {
                            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"

                            if document.data()!["gender"] == nil || document.data()!["gender"] as! String == "" {
                                wnd?.set(rootViewController: PersonalizeViewController(), options: options)
                            } else {
                                wnd?.set(rootViewController: ProfileViewController(), options: options)
                            }
                              print("Document data: \(dataDescription)")
                        } else {
                            AuthServices.shared.writeUserData(credentials: user) {
                                wnd?.set(rootViewController: ProfileViewController(), options: options)
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
