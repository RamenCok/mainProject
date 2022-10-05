//
//  ViewController.swift
//  mainProject
//
//  Created by Bryan Kenneth on 01/10/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var button: UIButton = {
        let button = ReusableButton(style: .delete, buttonText: "Button", selector: #selector(printYeuy), target: self)
        return button
    }()
    
    @objc func printYeuy(){
        print("Cuy")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        // Do any additional setup after loading the view.
    }


}

