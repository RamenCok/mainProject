//
//  BrandCatalogueVC + SearchBar Extensions.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 11/10/22.
//

import UIKit

extension BrandCatalogueViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}
