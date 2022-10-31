//
//  ProductCatalogueViewController.swift
//  mainProject
//
//  Created by Bryan Kenneth on 09/10/22.
//

import UIKit
import SnapKit
import Combine
import Firebase

protocol ProductCatalogueDelegate: AnyObject {
    
    func goToSignUp()
    func skip()
}

class ProductCatalogueViewController: UIViewController {
    
    var brand: Brands
    
    init(brand: Brands) {
        self.brand = brand
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var productList: [Product]!
    let productVM = ProductCatalogueViewModel(service: ProductService())
    
    var modalSize: Double?
    var presentedVC: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    // bikin product array
    
    // MARK: - Properties
    private lazy var productCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(ProductCollectionViewCell.self,
                                forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        
        collectionView.register(ProductCatalogueHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProductCatalogueHeaderView.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .backgroundColor
        
        return collectionView
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (view.frame.size.width/2)-25, height: view.frame.height * 0.3009478673)
        return layout
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView(image: UIImage(named: "noProduct"))
        return image
    }()
    
    private lazy var imageTitle: UILabel = {
        let label = ReusableLabel(style: .modalTitle, textString: "Oops! Nothing to see here...")
        label.textColor = UIColor("D5D5D5")
        return label
    }()
    
    private lazy var imageSubtitle: UILabel = {
        let label = ReusableLabel(style: .caption, textString: "There are no products under this\nbrand right now.")
        label.textColor = UIColor("D5D5D5")
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if brand.productRef.isEmpty {
            configureNoProduct()
        } else {
            productVM.productList
                .receive(on: RunLoop.main)
                .sink {list in
                self.configureUI()
                self.productList = list
                self.productCollectionView.reloadData()
            }.store(in: &cancellables)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productVM.fetchProductList(ref: brand.productRef)
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .navBar
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
        
        navigationItem.title = "\(brand.brandName)"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .primaryColor
        
        view.backgroundColor = .backgroundColor
        

    }
    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    func configureNoProduct() {
        
        view.backgroundColor = .backgroundColor
        
//        view.addSubview(rect)
//        rect.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.top.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
        
        view.addSubview(image)
        image.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(imageTitle)
        imageTitle.snp.makeConstraints { make in
            make.centerX.equalTo(image.snp.centerX)
            make.top.equalTo(image.snp.bottom)
        }
        
        view.addSubview(imageSubtitle)
        imageSubtitle.snp.makeConstraints { make in
            make.centerX.equalTo(image.snp.centerX)
            make.top.equalTo(imageTitle.snp.bottom).offset(5)
        }
    }
    
    func configureUI(){
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(productCollectionView)
        productCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension ProductCatalogueViewController: UIViewControllerTransitioningDelegate {
    
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

extension ProductCatalogueViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brand.productRef.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
        cell.contentView.layer.masksToBounds = false
        
        let sorted = productList.sorted { $0.productName < $1.productName }
        
        cell.productName = sorted[indexPath.row].productName
        cell.productImage = sorted[indexPath.row].productImage
        cell.colorsAsset = sorted[indexPath.row].colorsAsset.compactMap { $0["colors"] as? String }
        cell.configure()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sorted = productList.sorted { $0.productName < $1.productName }
        if let user = Auth.auth().currentUser {
            if user.isAnonymous {
                let slideVC = SignUpModalVC()
                slideVC.delegate = self
                presentedVC = slideVC.modalType
                modalSize = slideVC.modalSize
                slideVC.modalPresentationStyle = .custom
                slideVC.transitioningDelegate = self
                
                self.present(slideVC, animated: true, completion: nil)
                
                UserDefaults.standard.set(indexPath.row, forKey: "ProductDetail")
            }
        }
        navigationController?.pushViewController(ProductDetailVC(brandName: brand.brandName, product:  sorted[indexPath.row]), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProductCatalogueHeaderView.identifier, for: indexPath) as! ProductCatalogueHeaderView
        
        header.numberOfItem = productList.count
        header.configure()
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 50)
    }
}


extension ProductCatalogueViewController: ProductCatalogueDelegate {
    
    func goToSignUp() {
        self.navigationController?.pushViewController(SignupLogin(), animated: true)
    }
    
    func skip() {
        print("DEBUG: Go to product detail")
        let sorted = productList.sorted { $0.productName < $1.productName }
        let index = UserDefaults.standard.integer(forKey: "ProductDetail")
        self.navigationController?.pushViewController(ProductDetailVC(brandName: brand.brandName, product:  sorted[index]), animated: true)
    }
}

