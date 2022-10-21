//
//  ProductDetailVM.swift
//  mainProject
//
//  Created by Kevin Harijanto on 03/10/22.
//

import Foundation
import Combine

class ARModelsViewModel: ObservableObject {
    
    let model = PassthroughSubject<URL, Never>()
    
    let percentage = PassthroughSubject<Float, Never>()
    
    let isDownloading = PassthroughSubject<Bool, Never>()
    
    func asyncLoadModel(filename: String) {
        FirebaseStorageHelper().asyncDownloadToFileSystem(relativePath: filename) { fileUrl in
            self.model.send(fileUrl)
            print("DEBUG: Done!")
        } completion2: { percentage, isDownloading in
            self.percentage.send(percentage)
            self.isDownloading.send(isDownloading)
        }
    }
}
