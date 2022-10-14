//
//  BodyMeasurementVC.swift
//  mainProject
//
//  Created by Kevin Harijanto on 06/10/22.
//

import UIKit
import SnapKit

class BodyMeasurementVC: UIViewController {

    // MARK: - Properties
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "brand-catalogue")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var subtitle: UILabel = {
        let label = ReusableLabel(style: .subHeading_2, textString: "Setup your body measurement here")
        label.textColor = .white
        return label
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.frame.width / 2.3636363636, height: view.frame.height / 5.5894039735)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BodyMeasurementCell.self, forCellWithReuseIdentifier: BodyMeasurementCell.identifier)
//        collectionView.backgroundView = backgroundImage
        collectionView.backgroundColor = .clear
//        collectionView.delegate = self
//        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 20, bottom: 0, right: 20)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var vm =  BodyMeasurementVM()
    var user: User!
    
    var modalSize: Double?
    var presentedVC: String?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureNavigation()
        
        navigationItem.largeTitleDisplayMode = .always
        
        vm.getdata { [weak self] data in
            self?.user = data
            self?.configureUI()
        }
    }

    // MARK: - Selectors
    @objc func handleQuestionMarkButton() {
        
        let slideVC = SignUpModalVC()
        
        presentedVC = slideVC.modalType
        modalSize = slideVC.modalSize
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        
        self.present(slideVC, animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func configureNavigation() {

        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blackTexts, NSAttributedString.Key.font: UIFont.heading_1()]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.modalTitle()]
        self.title = "Body Measurement"

        let rightBarBtn = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(handleQuestionMarkButton))
        rightBarBtn.tintColor = .primaryColor
        navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    func configureUI() {
        
        view.backgroundColor = .systemBackground

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension BodyMeasurementVC: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        if presentedVC == "Tappable" {
            return DismissTappablePresentationController(
                modalTransitionSize: (view.frame.height/self.modalSize!)/view.frame.height,
                presentedViewController: presented,
                presenting: presenting
            )
        } else {
            return NotTappablePresentationController(
                modalTransitionSize: (view.frame.height/self.modalSize!)/view.frame.height,
                presentedViewController: presented,
                presenting: presenting
            )
        }
    }
}
