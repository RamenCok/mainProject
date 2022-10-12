//
//  BrandCatalogueVC + CollectionView Extensions.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 11/10/22.
//

import UIKit

extension BrandCatalogueViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            return searchedBrand.count
        } else {
            return brandList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCollectionViewCell.identifier, for: indexPath) as! BrandCollectionViewCell
        
        cell.contentView.layer.masksToBounds = false
        
        if searching {
            let sorted = searchedBrand.sorted { $0.brandName < $1.brandName }
            cell.brandName = sorted[indexPath.row].brandName
            cell.brandImage = sorted[indexPath.row].brandImage
        } else {
            let sorted = brandList.sorted { $0.brandName < $1.brandName }
            cell.brandName = sorted[indexPath.row].brandName
            cell.brandImage = sorted[indexPath.row].brandImage
        }
        
        cell.configure()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: \(indexPath.row)")
    }
    
}
