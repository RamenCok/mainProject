//
//  FirebaseStorageHelper.swift
//  mainProject
//
//  Created by Kevin Harijanto on 19/10/22.
//

import Foundation
import FirebaseStorage
import Combine

class FirebaseStorageHelper {
    
    func asyncDownloadToFileSystem(relativePath: String, completion: @escaping(_ fileUrl: URL)-> Void, completion2: @escaping(_ percentage: Float,_ isDownloading: Bool)-> Void) {
        // Create local filesystem url
        let docsUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileUrl = docsUrl.appendingPathComponent("\(relativePath).usdz")
        
        // Check if asset is already in the local filesystem, if it is, load that asset and return
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            completion(fileUrl)
            return
        }
        
        // Create a reference to the asset
        
        let storageRef = Storage.storage().reference(withPath: "Product3DAsset/\(relativePath).usdz")
        
        let downloadTask = storageRef.write(toFile: fileUrl)

        downloadTask.observe(.progress) { snapshot in
            let percentComplete = Float(snapshot.progress!.completedUnitCount) / Float(snapshot.progress!.totalUnitCount)
            // Update progress indicator
            if percentComplete == 1 {
                completion2(percentComplete, false)
            } else {
                completion2(percentComplete, true)
            }
            
        }

        downloadTask.observe(.success) { snapshot in
          // Download completed successfully
          // Stop progress indicator
            completion(fileUrl)
        }

        downloadTask.observe(.failure) { snapshot in
          // An error occurred!
          // Stop progress indicator
            downloadTask.resume()
        }
        
        // download to local filesystem
//        storageRef.write(toFile: fileUrl) { url, error in
//            guard let localUrl = url else {
//                print("DEBUG: Firebase Storage error downloading file with relativePath: \(relativePath) with error \(String(describing: error?.localizedDescription))")
//                return
//            }
//            print("DEBUG: Saved!")
//            completion(localUrl)
//        }
//        .resume()
        
    }
}

let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
let tempDirectory = URL.init(fileURLWithPath: paths, isDirectory: true)
let fileUrl = tempDirectory.appendingPathComponent("")
