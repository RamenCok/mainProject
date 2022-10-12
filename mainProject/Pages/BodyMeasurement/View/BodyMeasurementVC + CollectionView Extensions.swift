//
//  BodyMeasurementVC + CollectionView Extensions.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 11/10/22.
//

import UIKit

//extension BodyMeasurementVC: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return user.userBodyMeasurement.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BodyMeasurementCell.identifier, for: indexPath) as! BodyMeasurementCell
//        
//        let sorted = user.userBodyMeasurement.sorted {
//            return $0.key < $1.key
//        }
//        
//        cell.type = sorted[indexPath.row].key
//        cell.numbers = sorted[indexPath.row].value
//        
//        cell.layer.shadowColor = UIColor.systemGray5.cgColor
//        cell.layer.shadowOpacity = 0.15
//        cell.layer.shadowOffset = CGSize(width: 0, height: 8)
//        cell.layer.shadowRadius = 16
//        
//        cell.configure()
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//}
