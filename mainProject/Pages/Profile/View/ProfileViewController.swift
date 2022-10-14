//
//  ProfileViewController.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 05/10/22.
//

import UIKit
import SnapKit
import FirebaseAuth
import GoogleSignIn

class ProfileViewController: UIViewController {

    // MARK: - Properties
    private lazy var imageBG: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "profileBG")
        return image
    }()
    
    internal lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "initialProfilePicture")
        image.contentMode = .scaleAspectFill
        image.snp.makeConstraints { make in
            make.width.height.equalTo(view.frame.width / 2.203)
        }
        image.layer.masksToBounds = true
        image.layer.cornerRadius = (view.frame.width / 2.203) / 2
        return image
    }()
    
    private lazy var editProfileImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "editProfilePicture"), for: .normal)
        button.backgroundColor = UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 0.45)
        button.tintColor = .whiteColor
        button.alpha = 0
        button.snp.makeConstraints { make in
            make.width.height.equalTo(view.frame.width / 2.203)
        }
        button.layer.masksToBounds = true
        button.layer.cornerRadius = (view.frame.width / 2.203) / 2
        button.addTarget(self, action: #selector(handleEditProfilePicture), for: .touchUpInside)
        return button
    }()
    
    internal lazy var nameTF: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.backgroundColor = .clear
        tf.layer.cornerRadius = 15
        tf.isEnabled = false
        tf.font = UIFont.heading_3()
        tf.textColor = .blackTexts
        tf.snp.makeConstraints { make in
            make.height.equalTo(view.frame.height / 18)
        }
        tf.text = "Test"
        tf.returnKeyType = .done
        return tf
    }()
    
    private lazy var genderLabel: ReusableLabel = {
        let label = ReusableLabel(style: .subHeading_2, textString: "No Gender")
        label.backgroundColor = .clear
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.snp.makeConstraints { make in
            make.height.equalTo(view.frame.height / 18)
        }
        return label
    }()
    
    private lazy var maleMenuChildren: UIAction = {
        let action = UIAction(title: "Male") { action in
            self.genderLabel.text = "Male"
        }
        return action
    }()
    
    private lazy var femaleMenuChildren: UIAction = {
        let action = UIAction(title: "Female") { action in
            self.genderLabel.text = "Female"
        }
        return action
    }()
    
    private lazy var genderMenu: UIMenu = {
        let menu = UIMenu(children: [maleMenuChildren, femaleMenuChildren])
        return menu
    }()
    
    private lazy var genderButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.showsMenuAsPrimaryAction = true
        button.menu = genderMenu
        button.tintColor = .primaryColor
        button.alpha = 0
        return button
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
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backButtonTitle = ""
        
        super.viewDidLoad()
        configureUI()
        configureTextFieldObservers()
    }
    
    
    
    // MARK: - Selectors
    @objc func handleEditProfilePicture() {
        self.showImagePicker(selectedSource: .photoLibrary)
    }
    
    @objc func handleBodyMeasurementButton() {
        navigationController?.pushViewController(BodyMeasurementVC(), animated: true)
    }
    
    @objc func handleResetPasswordButton() {
        AuthServices.shared.resetPassword { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        print("Reset Password")
    }
    
    @objc func handleLogOutButton() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.disconnect()

            let loginVC = SignupLogin()
            view.window?.rootViewController = UINavigationController(rootViewController: loginVC) 
//            if var rootViewController = view.window?.rootViewController { // From iOS 13
//                rootViewController = loginVC
//                print("logout")
//            } else if var rootViewController = UIApplication.shared.windows.first?.rootViewController {
//                    rootViewController = loginVC
//                print("logout")
//            }

        } catch {
            print ("Error signing out: %@", error)
        }
        
        print("Log out")
    }
    
    // MARK: - Helpers
    func configureUI() {
        
        // To set transparent background for navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        
        let editBarButtonItem = self.editButtonItem
        let navItemAttribute = [
            NSAttributedString.Key.font: UIFont.bodyText()
        ]
        editBarButtonItem.setTitleTextAttributes(navItemAttribute, for: .normal)
        editBarButtonItem.tintColor = .primaryColor
        navigationItem.rightBarButtonItem = editBarButtonItem
    
        navigationController?.navigationBar.tintColor = .primaryColor
        
        view.addSubview(imageBG)
        imageBG.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.frame.height / 13.25)
        }
        
        view.addSubview(editProfileImageButton)
        editProfileImageButton.snp.makeConstraints { make in
            make.center.equalTo(profileImage.snp.center)
        }
        
        view.addSubview(nameTF)
        nameTF.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(view.frame.height / 46.89)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(genderLabel)
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTF.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(genderButton)
        genderButton.snp.makeConstraints { make in
            make.centerY.equalTo(genderLabel.snp.centerY)
            make.trailing.equalTo(genderLabel.snp.trailing)
            make.height.width.equalTo(view.frame.height / 18)
        }
        
        let stack = UIStackView(arrangedSubviews: [bodyMeasurementButton, resetPasswordButton])
        stack.axis = .vertical
        stack.spacing = 10
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).offset(view.frame.height / 33.76)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(logOutButton)
        logOutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-37)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {

        // overriding this method means we can attach custom functions to the button
        super.setEditing(editing, animated: animated)

        // attaching custom actions here
        if editing {
            
            print("Edit")
            UIView.animate(withDuration: 0.2) {
                self.editProfileImageButton.alpha = 1
                
                self.genderButton.alpha = 1
                self.genderLabel.backgroundColor = .systemGray6
                
                self.nameTF.isEnabled = true
                self.nameTF.backgroundColor = .systemGray6
            }
        } else {
            print("Done")
            UIView.animate(withDuration: 0.2) {
                self.editProfileImageButton.alpha = 0
                
                self.genderButton.alpha = 0
                self.genderLabel.backgroundColor = .clear
                
                self.nameTF.isEnabled = false
                self.nameTF.backgroundColor = .clear
            }
        }
    }
}
