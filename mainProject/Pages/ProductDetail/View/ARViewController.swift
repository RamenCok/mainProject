//
//  ARViewController.swift
//  mainProject
//
//  Created by Bryan Kenneth on 22/10/22.
//

import UIKit
import SceneKit
import ARKit
import SnapKit
import RealityKit
import AVFoundation
import Lottie

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    var filename: URL!
    let session: AVCaptureSession = AVCaptureSession()
    
    private lazy var sceneARView: ARView = {
        let view = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        return view
    }()
    
    private var animationView: LottieAnimationView {
        let animationView = LottieAnimationView.init(name: "arAnimation")
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
        let text = ReusableLabel(style: .heading_2, textString: "Point your Camera to a Flat Surface")
        text.textColor = .white
        text.textAlignment = .center
        animationView.addSubview(text)
        text.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.top).offset(animationView.frame.height * 0.2)
            make.centerX.equalTo(animationView.snp.centerX)
            make.width.equalTo(animationView.snp.width)
        }
        return animationView
    }
    
    private lazy var blurView: UIView = {
        let view = UIView()
//        let blur = UIBlurEffect(style: .regular)
//        let blurView = UIVisualEffectView(effect: blur)
//        blurView.frame = self.view.bounds
//        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(blurView)
        view.backgroundColor = .black
        
        view.addSubview(animationView)
//        animationView.snp.makeConstraints { make in
//            make.centerX.equalTo(view.snp.centerX)
//            make.centerY.equalTo(view.snp.centerY)
//        }
       

        
        return view
    }()
    
    private lazy var closeBtn: UIButton = {
        let button = ReusableButton(style: .primary, buttonText: "", selector: #selector(handleCloseBtn), target: self)
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
//        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return button
    }()
    
    @objc func handleCloseBtn() {
        print("Close")
        dismiss(animated: true)
    }
    
    init(filename: URL) {
        self.filename = filename
        print(filename)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        view.addSubview(sceneARView)
        sceneARView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(0)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
            make.top.equalTo(view.snp.top)
        }
        blurView.alpha = 0.8
        
        view.addSubview(closeBtn)
//        closeBtn.alpha = 2
        closeBtn.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(30)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            make.width.equalTo(80)
        }
        
        let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { (_) in
            print("done")
            UIView.animate(withDuration: 0.5, animations: {
                self.blurView.alpha = 0
            })
         }
//        timer.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
//        let anchor = AnchorEntity()
        let anchor = AnchorEntity(.plane([.horizontal, .vertical], classification: .any, minimumBounds: [0.2, 0.2]))
//        print(scene)
        let usdzModel = try! Entity.loadModel(contentsOf: filename)
        print("DEBUG: \(filename)")
        usdzModel.position = simd_make_float3(0, 0, 0)
//        usdzModel.scale = simd_make_float3(0.8, 0.8, 0.8)
        print(anchor.scale)
        anchor.addChild(usdzModel)
        
                
        
        sceneARView.scene.anchors.append(anchor)
//        sceneARView.addSubview(blurView)
//        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneARView.session.run(config, options: [])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneARView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print(error.localizedDescription)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print(session.configuration)
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
extension ARViewController: ARSessionDelegate {
    func setupForBodyTracking() {
        
    }
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        print("DEBUG: \(session)")
        print("DEBUG: \(anchors)")
    }
}
