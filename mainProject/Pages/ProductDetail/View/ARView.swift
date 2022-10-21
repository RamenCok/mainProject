//
//  ARView.swift
//  mainProject
//
//  Created by Kevin Harijanto on 04/10/22.
//

import UIKit
import SceneKit
import SceneKit.ModelIO

class ARView: UIView {
    
    // MARK: - Properties
    
    private var filename: String
    
    private lazy var sceneKitView: SCNView = {
        let view = SCNView()
        view.allowsCameraControl = true
        view.backgroundColor = .clear
        return view
    }()
    
    //MARK: - Lifecycle
    
    required init(filename: String) {
        self.filename = filename
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        
        setup3D()
        
        addSubview(sceneKitView)
        sceneKitView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.height.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers
    
    private func setup3D() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let tempDirectory = URL.init(fileURLWithPath: paths, isDirectory: true)
        let targetUrl = tempDirectory.appendingPathComponent("\(filename).usdz")
        
        let scene = try! SCNScene(url: targetUrl, options: [.checkConsistency: true])
        
        let light = SCNNode()
        light.light = SCNLight()
        light.light?.type = .ambient
        light.light?.temperature = 6700
    
        sceneKitView.scene = scene
        scene.rootNode.addChildNode(light)
        let camera = SCNNode()
        camera.camera = SCNCamera()
        scene.rootNode.addChildNode(camera)
    }
    
}
