//
//  BodyMeasurementVC.swift
//  mainProject
//
//  Created by Kevin Harijanto on 06/10/22.
//

import UIKit
import SnapKit
import Combine

protocol BodyMeasurementDelegate: AnyObject {
    func reload()
}

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
        collectionView.backgroundColor = .backgroundColor
        collectionView.backgroundView = backgroundImage
        collectionView.register(BodyMeasurementCell.self, forCellWithReuseIdentifier: BodyMeasurementCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 20, bottom: 0, right: 20)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .backgroundColor
        return collectionView
    }()
    
    internal var vm =  BodyMeasurementVM(service: Service())
    var user: User!
    
    var modalSize: Double?
    var presentedVC: String?
    
    var cancellables: Set<AnyCancellable> = []
    
    //MARK: Lifecycle
    init(user: User) {
        
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureNavigation()
        configureUI()
        
        navigationItem.largeTitleDisplayMode = .always
    }

    // MARK: - Selectors
    @objc func handleQuestionMarkButton() {
        
        print("Privacy GUNDULMU!")
    }
    
    //MARK: - Helpers
    func configureNavigation() {
        
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .backgroundColor
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.whiteColor,
            .font: UIFont.heading_1()
        ]
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.blackTexts!,
            .font: UIFont.modalTitle()
        ]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        
        self.title = "Body Measurement"

        let rightBarBtn = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(handleQuestionMarkButton))
        rightBarBtn.tintColor = .primaryColor
        navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    func configureUI() {
        
        view.backgroundColor = .backgroundColor

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

extension BodyMeasurementVC: BodyMeasurementDelegate {
    
    func reload() {
        
        vm.getUser()
        vm.user.sink { [weak self] user in
            self?.user = user
            print("DEBUG: \(user)")
            self?.collectionView.reloadData()
        }.store(in: &cancellables)
    }
}
