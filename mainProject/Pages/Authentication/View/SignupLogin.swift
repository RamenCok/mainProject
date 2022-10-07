//
//  SignupLogin.swift
//  mainProject
//
//  Created by Bryan Kenneth on 04/10/22.
//

import UIKit

class SignupLogin: UIViewController {

    // MARK: - Properties
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
        let button = ReusableButton(style: .secondary, buttonText: " Continue with Apple", selector: #selector(printYeuy), target: self)
        button.setImage(UIImage(systemName: "apple.logo"), for: .normal)
        button.tintColor = .primaryColor
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        return button
    }()
    
    private lazy var googleBtn: UIButton = {
        let button = ReusableButton(style: .secondary, buttonText: " Continue with Google", selector: #selector(printYeuy), target: self)
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
