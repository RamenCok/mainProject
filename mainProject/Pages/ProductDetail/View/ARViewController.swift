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

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    var filename: URL!
    
    private lazy var sceneARView: ARView = {
        let view = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        return view
    }()
    
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
        
        // Set the view's delegate
//        sceneARView.delegate = self
        
        // Show statistics such as fps and timing information
//        sceneARView.showsStatistics = true
//        let tempDirectory = URL.init(fileURLWithPath: paths, isDirectory: true)
//        let targetUrl = tempDirectory.appendingPathComponent("\(filename)")
        
//        let scene = try! SCNScene(url: filename, options: [.checkConsistency: true])
//        let scene = SCNScene(named: "AirForce.usdz")!
        
//        sceneARView.environment.sceneUnderstanding.options.insert(.physics)
        // Set the scene to the view
//        sceneARView.scene = scene
        
        view.addSubview(sceneARView)
        sceneARView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        let anchor = AnchorEntity(plane: .horizontal,
                                  classification: .any, // Plane classification can be set such as .floor and .any
                                  minimumBounds: [0.2,0.2])
//        let anchor = AnchorEntity(.body)
//        print(scene)
        let usdzModel = try! Entity.loadModel(contentsOf: filename)
        print("DEBUG: \(filename)")
        usdzModel.position = simd_make_float3(0, 0, 0)
//        usdzModel.scale = simd_make_float3(0.8, 0.8, 0.8)
        print(anchor.scale)
        anchor.addChild(usdzModel)
        sceneARView.scene.anchors.append(anchor)
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
