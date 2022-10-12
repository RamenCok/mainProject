//
//  OnboardingViewController.swift
//  mainProject
//
//  Created by Stephen Giovanni Saputra on 01/10/22.
//

import UIKit
import SnapKit

class OnboardingViewController: UIPageViewController {
    
    //MARK: - Properties
    var pages = [UIViewController]()
    let initialPage = 0
    
    internal lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .primaryColor
        pageControl.pageIndicatorTintColor = .systemGray3
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        pageControl.backgroundStyle = .minimal
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    internal lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(.primaryColor, for: .normal)
        button.titleLabel?.font = UIFont.bodyText()
        button.addTarget(self, action: #selector(handleSkipButton), for: .touchUpInside)
        return button
    }()
    
    internal lazy var getStartedButton: ReusableButton = {
        let button = ReusableButton(style: .primary, buttonText: "Next", selector: #selector(handleNextButton), target: self)
        return button
    }()
    
    //MARK: - Lifecycle
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
        
        delegate = self
        dataSource = self
    }
    
    //MARK: - Selectors
    @objc func handleNextButton() {
        
        print("Next button pressed")
        
        pageControl.currentPage += 1
        
        goToSpecificPage(index: pageControl.currentPage, ofViewControllers: pages)
        
        if pageControl.currentPage > 1 {
            getStartedButton.isEnabled = true
            skipButton.isEnabled = false
            UIView.animate(withDuration: 0.5) {
                self.getStartedButton.setTitle("Get Started", for: .normal)
                self.getStartedButton.removeTarget(self, action: #selector(self.handleNextButton), for: .touchUpInside)
                self.getStartedButton.addTarget(self, action: #selector(self.handleNavigationButton), for: .touchUpInside)
                self.skipButton.alpha = 0
            }
        }
    }
    
    @objc func handleNavigationButton() {
        
        let vc = BrandCatalogueViewController()
        let navController = UINavigationController(rootViewController: vc)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .coverVertical
        self.present(navController, animated: true)
    }
    
    @objc func handleSkipButton() {
        
        print("Skip Button...")
        
        let lastPage = pages.count - 1
        pageControl.currentPage = lastPage
        getStartedButton.isEnabled = true
        skipButton.isEnabled = false
        UIView.animate(withDuration: 0.5) {
            self.getStartedButton.setTitle("Get Started", for: .normal)
            self.getStartedButton.removeTarget(self, action: #selector(self.handleNextButton), for: .touchUpInside)
            self.getStartedButton.addTarget(self, action: #selector(self.handleNavigationButton), for: .touchUpInside)
            self.skipButton.alpha = 0
        }
        
        goToSpecificPage(index: lastPage, ofViewControllers: pages)
    }
    
    //MARK: - Helpers
    func configureUI() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(55)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        let page1 = OnboardingViewContainer(
            imageName: "onBoarding1",
            titleText: "Perfect fit, every time.",
            subtitleText: "With our size calculator feature,\nyou can know which size fits\nbest on you."
        )
        
        let page2 = OnboardingViewContainer(
            imageName: "onBoarding2",
            titleText: "Simple, yet intuitive.",
            subtitleText: "Our 3D model preview enables you\nto visualize products in a way that\nis quick and hassle-free."
        )
        
        let page3 = OnboardingViewContainer(
            imageName: "onBoarding3",
            titleText: "Try without\nbuy.",
            subtitleText: "Our Augmented Reality feature\ncan help you visualize how a product\nlooks on you."
        )
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        view.addSubview(getStartedButton)
        getStartedButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-(view.frame.height/40))
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(getStartedButton.snp.top).offset(-(view.frame.height/40))
        }
    }
}
