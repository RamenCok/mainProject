//
//  OnboardingViewContainer.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 01/10/22.
//

import UIKit
import SnapKit

class OnboardingViewContainer: UIViewController {
    
    // MARK: - Properties
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var titleLabel: ReusableLabel = {
        let label = ReusableLabel(style: .largeTitle_1, textString: "")
        return label
    }()
    
    private lazy var subtitleLabel: ReusableLabel = {
        let label = ReusableLabel(style: .subHeading_2, textString: "")
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var pinkCapsule: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tertiaryColor
        view.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(82)
        }
        view.layer.cornerRadius = 12.5
        return view
    }()
    
    //MARK: - Lifecycle
    init(imageName: String, titleText: String, subtitleText: String) {
        
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: imageName)
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 27
        paragraphStyle.minimumLineHeight = 27
        
        subtitleLabel.attributedText = NSAttributedString(
            string: subtitleText,
            attributes: [
                .paragraphStyle: paragraphStyle
            ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    
    //MARK: - Helpers
    func configureUI() {
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.frame.height/15.9)
            make.width.equalTo(view.frame.width)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.width - 40)
        }
        
        view.addSubview(pinkCapsule)
        pinkCapsule.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(imageView.snp.top).offset(-20)
        }
    }
}
