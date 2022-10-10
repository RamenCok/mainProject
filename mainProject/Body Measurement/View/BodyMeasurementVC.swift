//
//  BodyMeasurementVC.swift
//  mainProject
//
//  Created by Kevin Harijanto on 06/10/22.
//

import UIKit
import SnapKit

class BodyMeasurementVC: UIViewController {

    private var vm =  BodyMeasurementVM()
    var user: User!
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "brand-catalogue")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.frame.size.width * 0.423, height: view.frame.size.height * 0.22)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
//        collectionView.backgroundView = backgroundImage
        collectionView.register(BodyMeasurementCell.self, forCellWithReuseIdentifier: BodyMeasurementCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.getdata { [weak self] data in
            self?.user = data
            self?.configureUI()
        }
    }

    
    //MARK: Configure UI
    func configureNavigation() {
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blackTexts, NSAttributedString.Key.font: UIFont.heading_1()]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.modalTitle()]

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always

        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.title = "Body Measurement"
        self.navigationController?.title = "Body Measurementfolder.badge.questionmark"

        let rightBarBtn = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: nil)
        rightBarBtn.tintColor = .greyColor


        let currWidth = rightBarBtn.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = rightBarBtn.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}

extension BodyMeasurementVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.userBodyMeasurement.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BodyMeasurementCell.identifier, for: indexPath) as! BodyMeasurementCell
        
        let sorted = user.userBodyMeasurement.sorted {
            return $0.value < $1.value
        }
        
        cell.type = sorted[indexPath.row].key
        cell.numbers = sorted[indexPath.row].value
        (cell as! BodyMeasurementCell).configure()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
