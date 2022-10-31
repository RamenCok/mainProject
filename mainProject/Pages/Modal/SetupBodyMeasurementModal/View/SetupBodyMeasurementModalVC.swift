//
//  SetupBodyMeasurementModalVC.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 05/10/22.
//

import UIKit
import SnapKit

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
    
    private lazy var helperImageBG: UIView = {
        let view = UIView()
        view.backgroundColor = .bodyMeasurementModalBG
        return view
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
        tf.backgroundColor = .textFieldBG
        tf.attributedPlaceholder = NSAttributedString(
            string: "Input size",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray3]
        )
        tf.leftViewMode = .always
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 45))
        tf.leftViewMode = .always
        tf.textColor = .black
        tf.keyboardType = .numberPad
        tf.layer.cornerRadius = 14
        tf.font = UIFont.bodyText()
        tf.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        return tf
    }()
    
    var modalTitle: String?
    var helperImageName: String?
    
    let modalSize = 2.187
    let modalType = "NotTappable"
    
    let vm = SetupBodyMeasurementModalVM(service: Service())
    
    weak var delegate: BodyMeasurementDelegate?
    
    // MARK: - Lifecycle
    
    init(modalTitle: String, helperImageName: String, currentValue: Int) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalTitle = modalTitle
        self.helperImageName = helperImageName
        self.textField.text = String(currentValue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleDismiss() {
        self.dismiss(animated: true)
    }
    
    @objc func handleSave(sender: Any) {
        vm.updateData(type: modalTitle!, value: Int(textField.text!) ?? 0)
        delegate?.reload()
        self.dismiss(animated: true)
    }

    // MARK: - Helpers
    func configureUI() {
        
        view.backgroundColor = .backgroundColor
        
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
        let saveItem = UIBarButtonItem(title: "Save", style: .done, target: nil, action: #selector(handleSave))
        let navItemAttribute = [NSAttributedString.Key.font: UIFont.bodyText()]
        UIBarButtonItem.appearance().setTitleTextAttributes(navItemAttribute, for: .normal)
        UIBarButtonItem.appearance().tintColor = .label
        
        // Add Cancel button to the right
        navItem.rightBarButtonItem = saveItem
        navItem.leftBarButtonItem = cancelItem
        
        // Add all items to the navigation bar
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
        
        helperImageBG.addSubview(helperImage)
        helperImage.image = UIImage(named: helperImageName ?? "")
        helperImage.snp.makeConstraints { make in
            make.edges.equalTo(helperImageBG.snp.edges)
        }
        
        view.addSubview(helperImageBG)
        helperImageBG.snp.makeConstraints { make in
            make.height.equalTo(view.frame.height / 3.89)
            make.width.equalTo(view.frame.width)
            make.top.equalTo(navBar.snp.bottom).offset(15)
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
