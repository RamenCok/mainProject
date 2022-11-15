//
//  OneLastThingViewController.swift
//  mainProject
//
//  Created by Bryan Kenneth on 07/11/22.
//

import UIKit
import SnapKit

class OneLastThingViewController: UIViewController {
    // MARK: - Properties
    var user: User!
    
    private lazy var bgLogin: UIImageView = {
        let imageView = AuthBackground()
        return imageView
    }()
    
    private lazy var pinkTitle: UIStackView = {
        let sview = ReusableCapsuleTitle(title: "One Last Thing,")
        sview.spacing = view.frame.height * 0.019
        return sview
    }()
    
    private lazy var label: ReusableLabel = {
        let label = ReusableLabel(style: .bodyText, textString: "Setting up your body measurement allows you to use our size calculator feature.")
        label.lineBreakMode = .byClipping
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var letsGoBtn: ReusableButton = {
        let btn = ReusableButton(style: .primary, buttonText: "Let's Go", selector: #selector(handleLetsGo), target: self)
        return btn
    }()
    
    // MARK: - Lifecycle
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleLetsGo(){
        UserDefaults.standard.set(true, forKey: "fromOneLastThing")
        navigationController?.pushViewController(BodyMeasurementVC(user: user), animated: true)
        print("Let's Go")
    }
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .backgroundColor
        
        view.addSubview(bgLogin)
        bgLogin.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(pinkTitle)
        pinkTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(view.frame.height * 0.4691943128)
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalTo(pinkTitle.snp.bottom).offset(view.frame.height * 0.01303317536)
        }
        
        view.addSubview(letsGoBtn)
        letsGoBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-view.frame.height * 0.1469194313)
        }
        
    }

}
