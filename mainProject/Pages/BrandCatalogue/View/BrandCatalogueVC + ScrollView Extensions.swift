//
//  BrandCatalogueVC + ScrollView Extensions.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 11/10/22.
//

import UIKit

extension BrandCatalogueViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
        let svtop = scrollView.frame.origin.y
        let v3top = scrollView.superview! .convert(view.bounds.origin, from:view).y
        if v3top < svtop { print ("now") }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
          print("top!")
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("yay")
    }
    
    func moveAndResizeImage(for height: CGFloat) {
        
        let coeff: CGFloat = {
                let delta = height - Const.NavBarHeightSmallState
                let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
                return delta / heightDifferenceBetweenStates
            }()

            let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState

            let scale: CGFloat = {
                let sizeAddendumFactor = coeff * (1.0 - factor)
                return min(1.0, sizeAddendumFactor + factor)
            }()

            // Value of difference between icons for large and small states
            let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
            let yTranslation: CGFloat = {
                /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
                let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
                return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
            }()

            let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
            profileButton.transform = CGAffineTransform.identity
                .scaledBy(x: scale, y: scale)
                .translatedBy(x: xTranslation, y: yTranslation)
    }
}

struct Const {
    /// Image height/width for Large NavBar state
    static let ImageSizeForLargeState: CGFloat = 60
    /// Margin from right anchor of safe area to right anchor of Image
    static let ImageRightMargin: CGFloat = 20
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ImageBottomMarginForLargeState: CGFloat = 50
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let ImageBottomMarginForSmallState: CGFloat = 0
    /// Image height/width for Small NavBar state
    static let ImageSizeForSmallState: CGFloat = 10
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 76
}
