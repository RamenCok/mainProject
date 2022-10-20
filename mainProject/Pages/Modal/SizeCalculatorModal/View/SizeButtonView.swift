//
//  SizeButtonView.swift
//  ASHUReusableAsset
//
//  Created by Stephen Giovanni Saputra on 03/10/22.
//

import UIKit

class SizeButtonView: UIView {

    // MARK: - Properties
    private lazy var sizeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyText()
        label.textColor = .primaryColor
        return label
    }()
    
    var fontColor: UIColor = .primaryColor {
        didSet {
            sizeNameLabel.textColor = fontColor
        }
    }
    
    var sizeName: String = "" {
        didSet {
            sizeNameLabel.text = sizeName
        }
    }
    
    var sizeInt: Int = 0
    
    //MARK: - Lifecycle
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        commonInit()
    }

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
    }
    
    init(sizeName: String, sizeInt: Int) {
        
        self.sizeName = sizeName
        self.sizeInt = sizeInt
        
        super.init(frame: .zero)
        commonInit()
    }
    
    override func awakeFromNib() {
        setupEmojiContainer()
    }
    
    private func commonInit() {
        
        backgroundColor = UIColor.systemGray3
        
        addSubview(sizeNameLabel)
        sizeNameLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
        }
        
        setupEmojiContainer()
    }
    
    //MARK: - Helpers
    func setupEmojiContainer() {
        
        sizeNameLabel.text = sizeName
    }
}

//extension ViewController: UIViewControllerTransitioningDelegate {
//    
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        
//        if presentedVC == "Tappable" {
//            return DismissTappablePresentationController(
//                modalTransitionSize: (view.frame.height/self.modalSize)/view.frame.height,
//                presentedViewController: presented,
//                presenting: presenting
//            )
//        } else {
//            return NotTappablePresentationController(
//                modalTransitionSize: (view.frame.height/self.modalSize)/view.frame.height,
//                presentedViewController: presented,
//                presenting: presenting
//            )
//        }
//    }
//}
