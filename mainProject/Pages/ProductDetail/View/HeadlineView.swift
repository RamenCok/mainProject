//
//  HeadlineView.swift
//  mainProject
//
//  Created by Kevin Harijanto on 05/10/22.
//

import Foundation
import Firebase
import UIKit

class HeadlineView: UIView {
    // MARK: - Properties
    
    private var brandName: String
    private var product: Product

    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up")?.scalePreservingAspectRatio(targetSize: CGSize(width: 27, height: 27)).withRenderingMode(.alwaysTemplate), for: .normal)
//        button.backgroundColor = .cyan
        button.addTarget(self, action: #selector(handleShareButton), for: .touchUpInside)
        button.tintColor = .primaryButtonColor
        return button
    }()
    
    //MARK: - Lifecycle
    
    required init(brandName: String, product: Product) {
        self.brandName = brandName
        self.product = product
        super.init(frame: .zero)
        
        backgroundColor = .backgroundColor
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleShareButton() {
        print("share button clicked")
        createDynamicLink()
    }
    
    // MARK: - Helpers
    private func createDynamicLink(){
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil) {
             topVC = topVC!.presentedViewController
        }
       
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.bryankenneth.com"
        components.path = "/"
        
        let itemIDQueryItem = URLQueryItem(name: "productID", value: product.id)
        components.queryItems = [itemIDQueryItem]
        
        guard let linkParameter = components.url else { return }
        print("I am sharing \(linkParameter.absoluteString)")
        
        let domain = "https://fitze.page.link"
        
        guard let linkBuilder = DynamicLinkComponents
          .init(link: linkParameter, domainURIPrefix: domain) else {
            return
        }
        
        // 1
        if let myBundleId = Bundle.main.bundleIdentifier {
          linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        // 2
        linkBuilder.iOSParameters?.appStoreID = "1481444772"
        // 3
        linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder.socialMetaTagParameters?.title = "\(product.productName) is on Fitze"
        linkBuilder.socialMetaTagParameters?.descriptionText = product.productDesc
        linkBuilder.socialMetaTagParameters?.imageURL = URL(string: """
          https://pbs.twimg.com/profile_images/\
          1381909139345969153/tkgxJB3i_400x400.jpg
          """)!
        
        guard let longURL = linkBuilder.url else { return }
        print("DEBUG Long URL = \(longURL)")
        
        linkBuilder.shorten { url, warnings, error in
          if let error = error {
            print("Oh no! Got an error! \(error)")
            return
          }
          if let warnings = warnings {
            for warning in warnings {
              print("Warning: \(warning)")
            }
          }
          guard let url = url else { return }
          print("I have a short url to share! \(url.absoluteString)")
            
        // Setting description
            let firstActivityItem = "Check out \(self.product.productName) on Fitze"

                // Setting url
            let secondActivityItem : NSURL = url as NSURL
                
                // If you want to use an image
//                let image : UIImage = UIImage(named: "AppIcon")!
                let activityViewController : UIActivityViewController = UIActivityViewController(
                    activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
                
                // This lines is for the popover you need to show in iPad
            activityViewController.popoverPresentationController?.sourceView = (self.shareButton )
                
                // This line remove the arrow of the popover to show in iPad
                activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
                activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
                
                // Pre-configuring activity items
                activityViewController.activityItemsConfiguration = [
                UIActivity.ActivityType.message
                ] as? UIActivityItemsConfigurationReading
                
                // Anything you want to exclude
                activityViewController.excludedActivityTypes = [
                    UIActivity.ActivityType.postToWeibo,
                    UIActivity.ActivityType.print,
                    UIActivity.ActivityType.assignToContact,
                    UIActivity.ActivityType.saveToCameraRoll,
                    UIActivity.ActivityType.addToReadingList,
                    UIActivity.ActivityType.postToFlickr,
                    UIActivity.ActivityType.postToVimeo,
                    UIActivity.ActivityType.postToTencentWeibo,
                    UIActivity.ActivityType.postToFacebook
                ]
                
                activityViewController.isModalInPresentation = true
            topVC?.present(activityViewController, animated: true)
    //                self.present(activityViewController, animated: true, completion)
           
        }
        
    }
    
    private func configureUI() {
        let productHeadline = productHeadline(brandName: brandName, productName: product.productName)
        addSubview(productHeadline)
        productHeadline.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.height.equalTo(self)
        }
        
    }
    
    private func productHeadline(brandName: String, productName: String) -> UIView {
        let brandName = ReusableLabel(style: .productDetailBrand, textString: "\(brandName)")
        brandName.textColor = .blackTexts
        
        let productName = ReusableLabel(style: .heading_2, textString: "\(productName)")
        productName.numberOfLines = 2
        
        let productInfo = UIStackView(arrangedSubviews: [brandName, productName])
        productInfo.axis = .vertical
        productInfo.alignment = .leading
        productInfo.spacing = 3
        
        let productHeadline = UIStackView(arrangedSubviews: [productInfo, shareButton])
        productHeadline.axis = .horizontal
        productHeadline.alignment = .center
        productHeadline.distribution = .fill
        productHeadline.spacing = 10
        
//        productaddSubview(shareButton)
//        shareButton.alpha = 2
//        shareButton.snp.makeConstraints { make in
//            make.right.equalTo(self.snp.right).offset(0)
//            make.top.equalTo(self.snp.top).offset(0)
//        }
        return productHeadline
    }
}
