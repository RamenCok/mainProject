//
//  BrandCatalogueViewController.swift
//  mainProject
//
//  Created by Bryan Kenneth on 03/10/22.
//

import UIKit
import SnapKit
import Combine

class BrandCatalogueViewController: UIViewController {
    
    internal let vm =  BrandCatalogueViewModel(service: BrandService())
    internal var brandList: [Brands]!
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
        collectionView.backgroundColor = .clear
        //        collectionView.backgroundView = backgroundImage
        
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
        search.searchBar.searchTextField.backgroundColor = .white
        
        if let textfield = search.searchBar.value(forKey: "searchField") as? UITextField {
            //textfield.textColor = // Set text color
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
            }
        }
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.fetchBrandList()
        navigationItem.title = "Brands"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        showImage(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      showImage(false)
    }
    
    // MARK: - Selectors
    @objc func handleProfileButtonTapped() {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    //MARK: - Helpers
    func configureUI() {
        
        view.backgroundColor = .white
        
        searchBar.placeholder = "Your placeholder"
        searchBar.frame = CGRect(x: 0, y: 0, width: 200, height: 64)
        
        self.navigationItem.searchController = search
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blackTexts, NSAttributedString.Key.font: UIFont.heading_1()]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.modalTitle()]
        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
//        let rightBarBtn = UIBarButtonItem(customView: profileButton)
        
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
//        rightBarBtn.tintColor = .greyColor
//
//
//        let currWidth = rightBarBtn.customView?.widthAnchor.constraint(equalToConstant: 24)
//        currWidth?.isActive = true
//        let currHeight = rightBarBtn.customView?.heightAnchor.constraint(equalToConstant: 24)
//        currHeight?.isActive = true
//        navigationItem.rightBarButtonItem = rightBarBtn
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
