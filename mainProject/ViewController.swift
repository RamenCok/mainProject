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
        
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        if presentedVC == "Tappable" {
            return DismissTappablePresentationController(
                modalTransitionSize: (view.frame.height/self.modalSize)/view.frame.height,
                presentedViewController: presented,
                presenting: presenting
            )
        } else {
            return NotTappablePresentationController(
                modalTransitionSize: (view.frame.height/self.modalSize)/view.frame.height,
                presentedViewController: presented,
                presenting: presenting
            )
        }
    }
}

