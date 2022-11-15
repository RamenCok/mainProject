//
//  CheckInternetConnection.swift
//  mainProject
//
//  Created by Bryan Kenneth on 14/11/22.
//

import Foundation
import Network
import UIKit

class NetworkConnection {
    func checkConnection(){
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection")
                let alert = UIAlertController(title: "Connection Error", message: "No Internet detected. Please Check your connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                let wnd = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                DispatchQueue.main.async {
                    wnd!.rootViewController?.present(alert, animated: true)
                }
            }
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}
