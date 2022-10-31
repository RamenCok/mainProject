//
//  PrivacyModalVC.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 25/10/22.
//

import UIKit
import SnapKit

class PrivacyModalVC: UIViewController {
    
    // MARK: - Properties
    private lazy var heading: ReusableLabel = {
        let label = ReusableLabel(style: .heading_1, textString: "Why do we need your body measurement?")
        return label
    }()
    
    private lazy var subheading: ReusableLabel = {
        let label = ReusableLabel(style: .subHeading_2, textString: "Fitze wants to help you shop the right size. When the body measurements are accurate, the garments can fit perfectly. A well-fitted garment can enhance not only the look of the person but also the personality!")
        return label
    }()
    
    private lazy var understandButton: ReusableButton = {
        let button = ReusableButton(style: .primary, buttonText: "Alright!", selector: #selector(handleUnderstandButton), target: self)
        return button
    }()
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    let modalSize = 1.91
    let modalType = "NotTappable"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    // MARK: - Selectors
    @objc func handleUnderstandButton() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Helpers
    func configureUI() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(heading)
        heading.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(subheading)
        subheading.snp.makeConstraints { make in
            make.top.equalTo(heading.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(understandButton)
        understandButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-23)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
