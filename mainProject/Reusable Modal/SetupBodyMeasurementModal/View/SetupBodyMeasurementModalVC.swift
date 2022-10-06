//
//  SetupBodyMeasurementModalVC.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 05/10/22.
//

import UIKit

class SetupBodyMeasurementModalVC: UIViewController {
    
    // MARK: - Properties
    private lazy var helperImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width)
        }
        return image
    }()
    
    private lazy var lengthLabel: ReusableLabel = {
        let label = ReusableLabel(style: .heading_3, textString: "Length")
        return label
    }()
    
    private lazy var centimeterLabel: ReusableLabel = {
        let label = ReusableLabel(style: .subHeading_2, textString: "cm")
        label.textAlignment = .right
        label.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        return label
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .systemGray6
        tf.placeholder = "Input size"
        tf.leftViewMode = .always
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 45))
        tf.leftViewMode = .always
        tf.textColor = .blackTexts
        tf.keyboardType = .numberPad
        tf.layer.cornerRadius = 14
        tf.font = UIFont.bodyText()
        tf.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        tf.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        return tf
    }()
    
    var modalTitle: String?
    var helperImageName: String?
    
    let modalSize = 2.187
    let modalType = "NotTappable"
    
    init(modalTitle: String, helperImageName: String) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalTitle = modalTitle
        self.helperImageName = helperImageName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
        configureTextFieldObservers()
        
        slideViewWhenShowKeyboard(self, #selector(self.keyboardWillShow(notification:)), #selector(self.keyboardWillHide))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Selectors
    @objc func handleDismiss() {
        self.dismiss(animated: true)
    }
    
    @objc func tapDone(sender: Any) {
        textField.endEditing(true)
    }

    // MARK: - Helpers
    func configureUI() {
        
        view.backgroundColor = .systemBackground
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 44))
        
        // To set custom font for title
        let navItem = UINavigationItem(title: modalTitle ?? "")
        let navBarAttribute = [NSAttributedString.Key.font: UIFont.modalTitle()]
        navBar.titleTextAttributes = navBarAttribute
        UINavigationBar.appearance().titleTextAttributes = navBarAttribute
        
        // To set transparent background for navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        
        // To set bar items and custom font
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(handleDismiss))
        let saveItem = UIBarButtonItem(title: "Save", style: .done, target: nil, action: #selector(handleDismiss))
        let navItemAttribute = [NSAttributedString.Key.font: UIFont.bodyText()]
        UIBarButtonItem.appearance().setTitleTextAttributes(navItemAttribute, for: .normal)
        UIBarButtonItem.appearance().tintColor = .label
        
        // Add Cancel button to the right
        navItem.rightBarButtonItem = saveItem
        navItem.leftBarButtonItem = cancelItem
        
        // Add all items to the navigation bar
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
        
        view.addSubview(helperImage)
        helperImage.image = UIImage(named: helperImageName ?? "")
        helperImage.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(lengthLabel)
        lengthLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(helperImage.snp.bottom).offset(view.frame.height / 33.76)
        }
        
        let inputStack = UIStackView(arrangedSubviews: [textField, centimeterLabel])
        inputStack.axis = .horizontal
        inputStack.spacing = 20
        inputStack.distribution = .fill
        
        view.addSubview(inputStack)
        inputStack.snp.makeConstraints { make in
            make.centerY.equalTo(lengthLabel.snp.centerY)
            make.leading.equalTo(lengthLabel.snp.trailing).offset(view.frame.width / 4.48)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}

extension SetupBodyMeasurementModalVC {
    
    func slideViewWhenShowKeyboard(_ target: Any, _ actionShowKeyboard: Selector, _ actionHideKeyboard: Selector) {
        
        NotificationCenter.default.addObserver(target, selector: actionShowKeyboard, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(target, selector: actionHideKeyboard, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    func configureTextFieldObservers() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let bottomSpacing = self.view.frame.height - (lengthLabel.frame.origin.y + lengthLabel.frame.height)
            self.view.frame.origin.y -= keyboardHeight - bottomSpacing + 20
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let bottomSpacing = self.view.frame.height - (lengthLabel.frame.origin.y + lengthLabel.frame.height)
            self.view.frame.origin.y += keyboardHeight - bottomSpacing + 20
        }
    }
}
