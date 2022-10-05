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
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.primaryColor, for: .normal)
        button.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        return button
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
    
    private lazy var nameTF: UITextField = {
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
        
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleEdit() {
        print("Edit")
        UIView.animate(withDuration: 0.2) {
            self.editProfileImageButton.alpha = 1
            
            self.genderButton.alpha = 1
            self.genderLabel.backgroundColor = .systemGray6
            
            self.editButton.setTitle("Done", for: .normal)
            self.editButton.removeTarget(self, action: #selector(self.handleEdit), for: .touchUpInside)
            self.editButton.addTarget(self, action: #selector(self.handleDone), for: .touchUpInside)
            
            self.nameTF.isEnabled = true
            self.nameTF.backgroundColor = .systemGray6
        }
    }
    
    @objc func handleEditProfilePicture() {
        showAlert()
    }
    
    @objc func handleDone() {
        print("Done")
        UIView.animate(withDuration: 0.2) {
            self.editProfileImageButton.alpha = 0
            
            self.genderButton.alpha = 0
            self.genderLabel.backgroundColor = .clear
            
            self.editButton.setTitle("Edit", for: .normal)
            self.editButton.removeTarget(self, action: #selector(self.handleDone), for: .touchUpInside)
            self.editButton.addTarget(self, action: #selector(self.handleEdit), for: .touchUpInside)
            
            self.nameTF.isEnabled = false
            self.nameTF.backgroundColor = .clear
        }
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
    func configureUI() {
        
        view.addSubview(imageBG)
        imageBG.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview().offset(-20)
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
        
        view.addSubview(editProfileImageButton)
        editProfileImageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.frame.height / 11.25)
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
            make.trailing.equalTo(genderLabel.snp.trailing).offset(-15)
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
    
    func showAlert() {
        
        let alert = UIAlertController(title: "Select Image", message: "Where do you want to choose your recipe photo?", preferredStyle: .actionSheet)
        
        let cameraButton = UIAlertAction(title: "Camera", style: .default) { action in
            self.showImagePicker(selectedSource: .camera)
        }
        
        let galleryButton = UIAlertAction(title: "Photo Gallery", style: .default) { action in
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.view.tintColor = UIColor(named: "main")
        alert.addAction(cameraButton)
        alert.addAction(galleryButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePicker(selectedSource: UIImagePickerController.SourceType) {
        
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else { return }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = selectedSource
        imagePickerController.allowsEditing = true
        imagePickerController.view.tintColor = UIColor(named: "main")
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImage.image = selectedImage
        } else {
            print("Image not found")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
