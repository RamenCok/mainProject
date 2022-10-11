//
//  BrandCatalogueVC + CollectionView Extensions.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 11/10/22.
//

import UIKit

extension BrandCatalogueViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(brandVM.brandList.count)
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCollectionViewCell.identifier, for: indexPath)
        
        cell.contentView.layer.masksToBounds = false
        
        return cell
    }
}
