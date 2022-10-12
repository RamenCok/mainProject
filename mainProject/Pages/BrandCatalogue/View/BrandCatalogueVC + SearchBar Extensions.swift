//
//  BrandCatalogueVC + SearchBar Extensions.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 11/10/22.
//

import UIKit

extension BrandCatalogueViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            searching = true
            searchedBrand.removeAll()
            for brand in brandList {
                if brand.brandName.lowercased().contains(searchText.lowercased()) {
                    searchedBrand.append(brand)
                }
            }
        } else {
            searching = false
            searchedBrand.removeAll()
            searchedBrand = brandList
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchedBrand.removeAll()
        collectionView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}
