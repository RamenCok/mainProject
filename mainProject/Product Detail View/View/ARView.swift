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
        
        setup3DModel()
        
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
    
    private func setup3DModel() {
        guard let url = Bundle.main.url(forResource: "\(filename)", withExtension: "usdz") else { fatalError() }
        let mdlAsset = MDLAsset(url: url)
        let scene = SCNScene(mdlAsset: mdlAsset)
    
        let light = SCNNode()
        light.light = SCNLight()
        light.light?.type = .directional
        light.light?.temperature = 6500
    
        sceneKitView.scene = scene
        scene.rootNode.addChildNode(light)
    }
    
}
