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
        let button = ReusableButton(style: .secondary, buttonText: "Bust", selector: #selector(handleBustButton), target: self)
        return button
    }()
    
    private lazy var button2: UIButton = {
        let button = ReusableButton(style: .secondary, buttonText: "Waist", selector: #selector(handleWaistButton), target: self)
        return button
    }()
    
    private lazy var button3: UIButton = {
        let button = ReusableButton(style: .secondary, buttonText: "Height", selector: #selector(handleHeightButton), target: self)
        return button
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [button, button2, button3])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    var modalSize: Double = 0
    var presentedVC = ""
    
    @objc func handleBustButton(){
        
        let slideVC = SetupBodyMeasurementModalVC(modalTitle: "Bust", helperImageName: "bust-Woman")
        
        presentedVC = slideVC.modalType
        modalSize = slideVC.modalSize
        
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        
        self.present(slideVC, animated: true, completion: nil)
    }
    
    @objc func handleWaistButton(){
        
        let slideVC = SetupBodyMeasurementModalVC(modalTitle: "Waist", helperImageName: "waist-Woman")
        
        presentedVC = slideVC.modalType
        modalSize = slideVC.modalSize
        
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        
        self.present(slideVC, animated: true, completion: nil)
    }
    
    @objc func handleHeightButton(){
        
        let slideVC = SetupBodyMeasurementModalVC(modalTitle: "Height", helperImageName: "height-Woman")
        
        presentedVC = slideVC.modalType
        modalSize = slideVC.modalSize
        
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        
        self.present(slideVC, animated: true, completion: nil)
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

