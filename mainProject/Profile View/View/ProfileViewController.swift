//
//  ProfileViewController.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 05/10/22.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Properties
    private lazy var imageBG: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "profileBG")
        return image
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleEdit() {
        print("Test")
    }
    
    // MARK: - Helpers
    func configureUI()  {
        
        view.addSubview(imageBG)
        imageBG.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 44, width: view.frame.width, height: 44))
                
        // To set custom font for title
        let navItem = UINavigationItem()
        
        // To set transparent background for navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        
        // To set Cancel button and custom font
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: #selector(handleEdit))
        let navItemAttribute = [NSAttributedString.Key.font: UIFont.bodyText()]
        UIBarButtonItem.appearance().setTitleTextAttributes(navItemAttribute, for: .normal)
        UIBarButtonItem.appearance().tintColor = .label
        
        // Add Cancel button to the right
        navItem.rightBarButtonItem = cancelItem
        
        // Add all items to the navigation bar
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
    }
}
