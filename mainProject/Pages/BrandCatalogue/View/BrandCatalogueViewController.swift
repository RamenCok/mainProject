//
//  BrandCatalogueViewController.swift
//  mainProject
//
//  Created by Bryan Kenneth on 03/10/22.
//

import UIKit
import SnapKit
import Combine
import FirebaseAuth
import SDWebImage

class BrandCatalogueViewController: UIViewController {
    
    internal let vm =  BrandCatalogueViewModel(service: BrandService())
    internal var brandList: [Brands]!
    internal var profilePict: String!
    internal var brandImage: UIImage!
    private var cancellables: Set<AnyCancellable> = []
    
    
    internal var searching = false
    internal var searchedBrand = [Brands]()
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "brand-catalogue")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (view.frame.size.width/2)-25, height: (100/84 * (view.frame.size.width/2)))
        return layout
    }()
    
    internal lazy var profileButton: UIButton = {
       
        let button = UIButton()
        button.setImage(UIImage(named: "initialProfilePicture"), for: .normal)
        button.addTarget(self, action: #selector(handleProfileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    internal lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .backgroundColor
        collectionView.backgroundView = backgroundImage
        
        collectionView.register(BrandCollectionViewCell.self, forCellWithReuseIdentifier: BrandCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 20, bottom: 0, right: 20)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delaysContentTouches = false
        return collectionView
    }()
    
    internal lazy var search: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.searchBar.delegate = self
        search.searchBar.tintColor = .primaryColor
        search.searchBar.searchTextField.font = UIFont.bodyText()
        search.searchBar.placeholder = "Find brands"
        search.searchBar.searchTextField.backgroundColor = .backgroundColor
        return search
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
        // Panggil dari vm
        vm.brandList
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
            self?.brandList = data
            self?.configureCollectionView()
            self?.collectionView.reloadData()
        }.store(in: &cancellables)
        vm.userProfile
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                let url = URL(string: data)
                if url != nil {
                    self?.profileButton.sd_setImage(with: url, for: .normal)
                } else {
                    self?.profileButton.setImage(UIImage(named: "initialProfilePicture"), for: .normal)
                }
        }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.fetchBrandList()
        vm.fetchUserProfile()
        navigationItem.title = "Brands"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        profileButton.alpha = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profileButton.alpha = 0
    }
    
    // MARK: - Selectors
    @objc func handleProfileButtonTapped() {
        if let user = Auth.auth().currentUser {
            if user.isAnonymous {
                profileButton.alpha = 0
                navigationController?.pushViewController(SignupLogin(), animated: true)
            } else {
                profileButton.alpha = 0
                navigationController?.pushViewController(ProfileViewController(), animated: true)
            }
        }
    }
    
    //MARK: - Helpers
    func configureUI() {
        
        view.backgroundColor = .backgroundColor
        
        searchBar.frame = CGRect(x: 0, y: 0, width: 200, height: 64)
        
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
        
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(profileButton)
        profileButton.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        profileButton.imageView?.contentMode = .scaleAspectFill
        profileButton.clipsToBounds = true
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            profileButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            profileButton.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            profileButton.widthAnchor.constraint(equalTo: profileButton.heightAnchor)
        ])
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func showImage(_ show: Bool) {
        
        UIView.animate(withDuration: 0.25) {
            self.profileButton.alpha = show ? 1.0 : 0.0
        }
    }
}
