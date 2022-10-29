//
//  PersonalizeViewController.swift
//  mainProject
//
//  Created by Bryan Kenneth on 06/10/22.
//

import UIKit
import Combine
import UIWindowTransitions
import SnapKit

class PersonalizeViewController: UIViewController {

    let vm = PersonalizeViewModel(service: UserService())
    var user: User!
    var cancellables = Set<AnyCancellable>()
    // MARK: - Properties
    private lazy var bgLogin: UIImageView = {
        let imageView = AuthBackground()
        return imageView
    }()
    
    private lazy var pinkTitle: UIStackView = {
        let sview = ReusableCapsuleTitle(title: "Let’s personalize your account")
        sview.spacing = view.frame.height * 0.019
        return sview
    }()
    
    private lazy var nameTextField: TextField = {
        let textField = ReusableTextFieldAuth(placeholders: "Your Name")
        return textField
    }()
    
    private lazy var genderLabel: ReusableTextFieldAuth = {
        let label = ReusableTextFieldAuth(placeholders: "No Gender")
        label.text = "No Gender"
        label.isEnabled = false
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
           button.tintColor = UIColor.rgb(red: 35, green: 49, blue: 97, alpha: 1)
           button.alpha = 1
           return button
       }()
    
    private lazy var saveButton: ReusableButton = {
        let reusableBtn = ReusableButton(style: .primary, buttonText: "Save", selector: #selector(handleSave), target: self)
//        reusableBtn.makeDisabled(isDisabled: true)
        return reusableBtn
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        vm.userInfo.sink { user in
            self.user = user
            self.nameTextField.text = user.userName
            self.genderLabel.text = user.userGender != "" ? user.userGender : "No Gender"
        }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vm.fetchUser()
    }
    
    // MARK: - Selectors
    @objc func handleSave(){
        if genderLabel.text != "No Gender" && nameTextField.text != "" {
            let updatedUserData = [
                "gender": genderLabel.text,
                "name": nameTextField.text
            ]
            vm.saveData(updatedData: updatedUserData) {
                let wnd = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                var options = UIWindow.TransitionOptions()
                options.direction = .toRight
                options.duration = 0.4
                options.style = .easeIn
                wnd?.set(rootViewController: UINavigationController(rootViewController: BrandCatalogueViewController()), options: options)
            }
            
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        
        view.backgroundColor = .backgroundColor
        
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
        
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(pinkTitle.snp.bottom).offset(view.frame.height*0.0569)
            make.height.equalTo(view.frame.height*0.055)
        }
        
        view.addSubview(genderLabel)
        genderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(nameTextField.snp.bottom).offset(view.frame.height * 0.01421800948)
            make.height.equalTo(view.frame.height*0.055)
        }
        
        view.addSubview(genderButton)
        genderButton.snp.makeConstraints { make in
            make.centerY.equalTo(genderLabel.snp.centerY)
            make.trailing.equalTo(genderLabel.snp.trailing)
            make.height.width.equalTo(view.frame.height / 18)
        }
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-view.frame.height * 0.1469194313)
        }
        
    }

}
