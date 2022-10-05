//
//  ProfileViewController.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 05/10/22.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {

    // MARK: - Properties
    private lazy var imageBG: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "profileBG")
        return image
    }()
    
    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "initialProfilePicture")
        image.snp.makeConstraints { make in
            make.width.height.equalTo(view.frame.width / 2.203)
        }
        image.layer.masksToBounds = true
        image.layer.cornerRadius = (view.frame.width / 2.203) / 2
        return image
    }()
    
    private lazy var bodyMeasurementButton: ReusableProfileButtonView = {
        let button = ReusableProfileButtonView(logo: "ruler", buttonText: "Body Measurement", selector: #selector(handleBodyMeasurementButton), target: self)
        return button
    }()
    
    private lazy var resetPasswordButton: ReusableProfileButtonView = {
        let button = ReusableProfileButtonView(logo: "key", buttonText: "Reset Password", selector: #selector(handleResetPasswordButton), target: self)
        return button
    }()
    
    private lazy var logOutButton: ReusableButton = {
        let button = ReusableButton(style: .delete, buttonText: "Log out", selector: #selector(handleLogOutButton), target: self)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleEdit() {
        print("Edit")
    }
    
    @objc func handleBodyMeasurementButton() {
        print("Body Measurement")
    }
    
    @objc func handleResetPasswordButton() {
        print("Reset Password")
    }
    
    @objc func handleLogOutButton() {
        print("Log out")
    }
    
    // MARK: - Helpers
    func configureUI()  {
        
        view.addSubview(imageBG)
        imageBG.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        // To set transparent background for navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        
        view.addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.frame.height / 11.25)
        }
        
        view.addSubview(logOutButton)
        logOutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-37)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        let stack = UIStackView(arrangedSubviews: [bodyMeasurementButton, resetPasswordButton])
        stack.axis = .vertical
        stack.spacing = 10
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.bottom.equalTo(logOutButton.snp.top).offset(-(view.frame.height / 5.861))
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
    }
}
