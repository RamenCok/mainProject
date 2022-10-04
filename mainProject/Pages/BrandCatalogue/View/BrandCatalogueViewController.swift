//
//  BrandCatalogueViewController.swift
//  mainProject
//
//  Created by Bryan Kenneth on 03/10/22.
//

import UIKit
import SnapKit
class BrandCatalogueViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UISearchControllerDelegate, UISearchBarDelegate {
    
    
    
    private var brandVM =  BrandCatalogueViewModel()
    
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
    
    private lazy var profileButton: UIButton = {
       
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.setImage(UIImage(named: "profile-icon"), for: .normal)
        button.tintColor = .gray
        button.clipsToBounds = true
        button.layer.cornerRadius = 0.5 * button.bounds.size.width

        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
//        collectionView.backgroundView = backgroundImage
        
        collectionView.register(BrandCollectionViewCell.self, forCellWithReuseIdentifier: BrandCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    
    private lazy var search: UISearchController = {
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
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;

            }
        }
        return search
    }()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("masuk")
        
       configureUI()
    }

    
    //MARK: Configure UI
    func configureUI() {
        
        view.backgroundColor = .white

        searchBar.placeholder = "Your placeholder"
        searchBar.frame = CGRect(x: 0, y: 0, width: 200, height: 64)
        
        self.navigationItem.searchController = search
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blackTexts, NSAttributedString.Key.font: UIFont.heading_1()]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.modalTitle()]
        
        
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.title = "Brands"
        self.navigationController?.title = "Brands"
        
        let rightBarBtn = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"), style: .plain, target: self, action: nil)
        rightBarBtn.tintColor = .greyColor
     

        let currWidth = rightBarBtn.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = rightBarBtn.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        navigationItem.rightBarButtonItem = rightBarBtn
        

    }
    
   
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(brandVM.brandList.count)
        return brandVM.brandList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCollectionViewCell.identifier, for: indexPath)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let svtop = scrollView.frame.origin.y
        let v3top = scrollView.superview! .convert(view.bounds.origin, from:view).y
        if v3top < svtop { print ("now") }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
          print("top!")
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("yay")
    }

   
    

    

}
