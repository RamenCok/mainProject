//
//  SizeCalcViewModel.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 17/10/22.
//

import Foundation
import Combine
import UIKit

class SizeCalcViewModel: ObservableObject {
    
    var chest: Int = 0
    var waist: Int = 0
    var height: Int = 0
    var currentSize: Int = -1
    
    var recommendedSize = -1
    var aggregate = 0
    
    var sortedChest = [Dictionary<Int, Int>.Element]()
    var sortedWaist = [Dictionary<Int, Int>.Element]()
    var sortedHeight = [Dictionary<Int, Int>.Element]()
    
    var sellerWaist = [Dictionary<Int, Int>.Element]()
    var sellerHeight = [Dictionary<Int, Int>.Element]()
    var sellerChest = [Dictionary<Int, Int>.Element]()
    
    // MARK: - Find Recommended Size
    func appendSizeChart(productSizeChart: [ProductSizeChart]) {
        print(productSizeChart)
        for size in productSizeChart {
            
            sellerWaist.append((size.sizeName, size.sizeDimension["waist"]!))
            sellerChest.append((size.sizeName, size.sizeDimension["chest"]!))
            sellerHeight.append((size.sizeName, size.sizeDimension["height"]!))
        }
    }
    
    func recommendationSize(chestUser: Int, waistUser: Int, heightUser: Int, productSizeChart: [ProductSizeChart]) -> String {
        
        chest = chestUser
        waist = waistUser
        height = heightUser
        
        appendSizeChart(productSizeChart: productSizeChart)
        
        if checkNoSize() {
            
            let chest = checkChest(userChest: chestUser)
            let waist = checkWaist(userWaist: waistUser)
            let height = checkHeight(userHeight: heightUser)
            
            let recommendedParts = [chest, waist, height]
            
            recommendedSize = recommendedParts.max()!
            currentSize = recommendedParts.max()!
            
            return (convertSize(input: recommendedParts.max()!))
        } else {
            return ("No Size")
        }
    }
    
    func checkNoSize() -> Bool {
        
        // Buat melakukan sorting data chest seller
        sortedChest = sellerChest.sorted {
            return $0.key < $1.key
        }

        // Buat melakukan sorting data waist seller
        sortedWaist = sellerWaist.sorted {
            return $0.key < $1.key
        }

        // Buat melakukan sorting data height seller
        sortedHeight = sellerHeight.sorted {
            return $0.key < $1.key
        }
        
        if (chest < sortedChest.first!.1 - 5 || chest > sortedChest.last!.1 + 5) {
            return false
        } else if (waist < sortedWaist.first!.1 - 5 || waist > sortedWaist.last!.1 + 5) {
            return false
        } else if (height < sortedHeight.first!.1 - 5 || height > sortedHeight.last!.1 + 5) {
            return false
        } else {
            return true
        }
        
    }

    func checkChest(userChest: Int) -> Int {
        
        for size in sortedChest {
            if chest <= size.value {
                recommendedSize = size.key
                if aggregate < size.key {
                    aggregate = size.key
                }
                break
            } else {
                recommendedSize = size.key
            }
        }
        
        return recommendedSize
    }

    func checkWaist(userWaist: Int) -> Int {
        
        for size in sortedWaist {
            if waist <= size.value {
                recommendedSize = size.key
                if aggregate < size.key {
                    aggregate = size.key
                }
                break
            } else {
                recommendedSize = size.key
            }
        }
        
        return recommendedSize
    }

    func checkHeight(userHeight: Int) -> Int {
        
        for size in sortedHeight {
            if height <= size.value {
                recommendedSize = size.key
                break
            } else {
                recommendedSize = size.key
            }
        }
        
        return recommendedSize
    }
    
    // MARK: - Generating Description Functions
    func setChestButtonImage(currSize: Int) -> String {

        if chest <= sortedChest[currSize].value {
            return "fit"
        } else {
            return "unfit"
        }
    }
    
    func setChestButtonImageClicked(currSize: Int) -> String {

        if chest <= sortedChest[currSize].value {
            return "fit-selected"
        } else {
            return "unfit-selected"
        }
    }
    
    func setHeightButtonImage(currSize: Int) -> String {
        
        if height <= sortedHeight[currSize].value {
            return "fit"
        } else {
            return "unfit"
        }
    }
    
    func setHeightButtonImageClicked(currSize: Int) -> String {
        
        if height <= sortedHeight[currSize].value {
            return "fit-selected"
        } else {
            return "unfit-selected"
        }
    }
    
    func setWaistButtonImage(currSize: Int) -> String {
        
        if waist <= sortedWaist[currSize].value {
            return "fit"
        } else {
            return "unfit"
        }
    }
    
    func setWaistButtonImageClicked(currSize: Int) -> String {
        
        if waist <= sortedWaist[currSize].value {
            return "fit-selected"
        } else {
            return "unfit-selected"
        }
    }
    
    func setChestButtonMessage(currSize: Int) -> (overallFit: String, color: UIColor, productSize: Int, buyerSize: Int) {
        
        if chest <= sortedChest[currSize].value {
            return ("Fit", UIColor.greenColor!, sortedChest[currSize].value, chest)
        } else {
            return ("Too tight", UIColor.redColor!, sortedChest[currSize].value, chest)
        }
    }
    
    func setHeightButtonMessage(currSize: Int) -> (overallFit: String, color: UIColor, productSize: Int, buyerSize: Int) {
        
        if height <= sortedHeight[currSize].value {
            return ("Fit", UIColor.greenColor!, sortedHeight[currSize].value, height)
        } else {
            return ("Too tight", UIColor.redColor!, sortedHeight[currSize].value, height)
        }
    }
    
    func setWaistButtonMessage(currSize: Int) -> (overallFit: String, color: UIColor, productSize: Int, buyerSize: Int) {
        
        if waist <= sortedWaist[currSize].value {
            return ("Fit", UIColor.greenColor!, sortedWaist[currSize].value, waist)
        } else {
            return ("Too tight", UIColor.redColor!, sortedWaist[currSize].value, waist)
        }
    }
    
    // MARK: - Other Functions
    func setupSizeButton() -> [SizeButtonView] {
        
        var sizes: [SizeButtonView] = []
        
        for size in sortedChest {
            
            let button = SizeButtonView(
                sizeName: convertSize(input: size.key),
                sizeInt: size.key
            )
            
            sizes.append(button)
        }
        
        return sizes
    }
    
    func convertSize(input: Int) -> String {
        
        switch input {
            case -1:
                return "No size"
            case 0:
                return "XS"
            case 1:
                return "S"
            case 2:
                return "M"
            case 3:
                return "L"
            case 4:
                return "XL"
            default:
                return "No Size"
        }
    }
}
