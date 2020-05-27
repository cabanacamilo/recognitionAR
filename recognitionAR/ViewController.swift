//
//  ViewController.swift
//  recognitionAR
//
//  Created by Camilo Cabana on 27/05/20.
//  Copyright © 2020 Camilo Cabana. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
        let configuration = ARImageTrackingConfiguration()
        guard let trackingImage = ARReferenceImage.referenceImages(inGroupNamed: "Test", bundle: nil) else { fatalError("could not do traking image")}
        configuration.trackingImages = trackingImage
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
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
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil}
        //get the image
        guard let name = imageAnchor.referenceImage.name else { return nil }
        var rendererName = String()
        var rendererInfo = String()
        var rendererImage = String()
        if name == "joker" {
            rendererName = "Joker Card"
            rendererInfo = "You cannot use this card in poker"
            rendererImage = "cards"
        } else {
            rendererName = "J Diamonds Card"
            rendererInfo = "You can use this card in poker"
            rendererImage = "poker"
        }
        //create a plane
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor.clear
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
        //add plane
        let node  = SCNNode()
        node.addChildNode(planeNode)
        // text
        let spacing: Float = 0.4
        let titleNode = textNode(rendererName, font: UIFont.boldSystemFont(ofSize: 10))
        titleNode.pivotTopLeft()
        titleNode.position.x += Float(plane.width / 2) + spacing
        titleNode.position.y += Float(plane.height / 2)
        planeNode.addChildNode(titleNode)
        
        let infoNode = textNode(rendererInfo, font: UIFont.systemFont(ofSize: 5), maxWidth: 100)
        infoNode.pivotTopLeft()
        infoNode.position.x += Float(plane.width / 2) + spacing
        infoNode.position.y = titleNode.position.y - titleNode.height - spacing
        planeNode.addChildNode(infoNode)
        
        let image = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width / 2, height: imageAnchor.referenceImage.physicalSize.width / 2)
        image.firstMaterial?.diffuse.contents = UIImage(named: rendererImage)
        
        let imageNode = SCNNode(geometry: image)
        imageNode.pivotTopCenter()
        imageNode.position.y -= Float(plane.height / 2) - Float(image.height / 2)
        planeNode.addChildNode(imageNode)
        
        return node
    }
    
    func textNode(_ str: String, font: UIFont, maxWidth: Int? = nil) -> SCNNode {
        let text = SCNText(string: str, extrusionDepth: 0)
        text.flatness = 0.1
        text.font = font
        if let maxWidth = maxWidth {
            text.containerFrame = CGRect(origin: .zero, size: CGSize(width: maxWidth, height: 500))
            text.isWrapped = true
        }
        let textNode = SCNNode(geometry: text)
        textNode.scale = SCNVector3(0.1, 0.1, 0.1)
        return textNode
    }
}

extension SCNNode {
    
    var width: Float {
        return (boundingBox.max.x - boundingBox.min.x) * scale.x
    }
    
    var height: Float {
        return (boundingBox.max.y - boundingBox.min.y) * scale.y
    }
    
    func pivotTopLeft() {
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation(min.x, (max.y - min.y) + min.y, 0)
    }
    
    func pivotTopCenter() {
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation((max.x - min.x) / 2 + min.x, (max.y - min.y) + min.y, 0)
    }
}
