//
//  BuyModalVM.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 04/10/22.
//

import Foundation

class BuyModalVM {
    
    // Number of buttons bisa diganti dengan jumlah link waktu narik data
    func setModalHeight(numberOfButtons: Int) -> Double {
        switch numberOfButtons {
        case 1:
            return 4.15
        case 2:
            return 3.55
        case 3:
            return 2.95
        case 4:
            return 2.35
        case 5:
            return 2.05
        default:
            return 1.5
        }
    }
}
