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
    
    private lazy var sceneKitView: SCNView = {
        let view = SCNView()
        view.allowsCameraControl = true
        view.backgroundColor = .clear
        return view
    }()
    
    //MARK: - Lifecycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .systemBackground
        
        setup3DModel()
        
        addSubview(sceneKitView)
        sceneKitView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.height.equalTo(self)
        }
    }
    
    private func setup3DModel() {
        guard let url = Bundle.main.url(forResource: "AirForce", withExtension: "usdz") else { fatalError() }
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
