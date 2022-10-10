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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var vm =  BodyMeasurementVM()
    var user: User!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureNavigation()
        
        vm.getdata { [weak self] data in
            self?.user = data
            self?.configureUI()
        }
    }

    // MARK: - Selectors
    
    
    //MARK: - Helpers
    func configureNavigation() {
//
//        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blackTexts, NSAttributedString.Key.font: UIFont.heading_1()]
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.modalTitle()]
//
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationItem.largeTitleDisplayMode = .always
//
//        self.navigationItem.hidesSearchBarWhenScrolling = false
//        self.title = "Body Measurement"
//        self.navigationController?.title = "Body Measurementfolder.badge.questionmark"

//        let rightBarBtn = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: nil)
//        rightBarBtn.tintColor = .greyColor
//
//        let currWidth = rightBarBtn.customView?.widthAnchor.constraint(equalToConstant: 24)
//        currWidth?.isActive = true
//        let currHeight = rightBarBtn.customView?.heightAnchor.constraint(equalToConstant: 24)
//        currHeight?.isActive = true
//        navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    func configureUI() {
        
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(subtitle)
        subtitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(subtitle.snp.bottom).offset(20)
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
            return $0.key < $1.key
        }
        
        cell.type = sorted[indexPath.row].key
        cell.numbers = sorted[indexPath.row].value
        cell.configure()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
