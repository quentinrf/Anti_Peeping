//
//  TransformViewController.swift
//  Anti_Peep
//
//  Created by Quentin Roy-Foster on 2021-03-04.
//  Copyright © 2021 XQProductions. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import SceneKit

class TransformViewController: UIViewController, ARSessionDelegate {
    
    let sceneView = ARSCNView(frame: UIScreen.main.bounds)
    
    var contentControllers: [VirtualContentType: VirtualContentController] = [:]
    
    
    var selectedVirtualContent: VirtualContentType! {
        didSet {
            guard oldValue != nil, oldValue != selectedVirtualContent
                else { return }
            
            // Remove existing content when switching types.
            contentControllers[oldValue]?.contentNode?.removeFromParentNode()
            
            // If there's an anchor already (switching content), get the content controller to place initial content.
            // Otherwise, the content controller will place it in `renderer(_:didAdd:for:)`.
            if let anchor = currentFaceAnchor, let node = sceneView.node(for: anchor),
                let newContent = selectedContentController.renderer(sceneView, nodeFor: anchor) {
                node.addChildNode(newContent)
            }
        }
    }
    
    
    var selectedContentController: VirtualContentController {
        if let controller = contentControllers[selectedVirtualContent] {
            return controller
        } else {
            let controller = selectedVirtualContent.makeController()
            contentControllers[selectedVirtualContent] = controller
            return controller
        }
    }
    
    var currentFaceAnchor: ARFaceAnchor?
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            self.view.addSubview(sceneView)
            sceneView.delegate = self
            sceneView.session.delegate = self
            sceneView.automaticallyUpdatesLighting = true
            setupLabel()
            //NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshLbl:", name: "refresh", object: nil)
        
//            guard ARFaceTrackingConfiguration.isSupported else { return }
//            let configuration = ARFaceTrackingConfiguration()
//            configuration.isLightEstimationEnabled = true
//            sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
            //tabBar.selectedItem = tabBar.items!.first!
            selectedVirtualContent = VirtualContentType(rawValue: 0)
        }
    
//    func refreshLbl(notification: NSNotification) {
//
//        print("Received Notification")
//        faceCountFD.text = "NilNILNILNILNILNIL"
//    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // AR experiences typically involve moving the device without
        // touch input for some time, so prevent auto screen dimming.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // "Reset" to run the AR session for the first time.
        resetTracking()
    }
    
    // Face Detection Face Count UI Label
    let faceCountFD: UILabel = {
        let label = UILabel()
        label.text = "hellohellohellohellohellovhello"
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightText
        label.font = UIFont(name: "Avenir-Heavy", size: 30)
        return label
    }()
    
    
    fileprivate func setupLabel() {
        view.addSubview(faceCountFD)
        faceCountFD.translatesAutoresizingMaskIntoConstraints = false
        let widthContraints =  NSLayoutConstraint(item: faceCountFD, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200)
            
        let heightContraints = NSLayoutConstraint(item: faceCountFD, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80)
        
        let xContraints = NSLayoutConstraint(item: faceCountFD, attribute: NSLayoutConstraint.Attribute.bottomMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1, constant: -20)
        
        let yContraints = NSLayoutConstraint(item: faceCountFD, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -200)
        
        NSLayoutConstraint.activate([heightContraints,widthContraints,xContraints,yContraints])
    }
    
    
    // MARK: - ARSessionDelegate

    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
        }
    }
    
    /// - Tag: ARFaceTrackingSetup
    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // MARK: - Error handling
    
    func displayErrorMessage(title: String, message: String) {
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.resetTracking()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension TransformViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let contentType = VirtualContentType(rawValue: 0)
            else { fatalError("unexpected virtual content tag") }
        selectedVirtualContent = contentType
    }
}


extension TransformViewController: ARSCNViewDelegate {
        
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        currentFaceAnchor = faceAnchor
        
        // If this is the first time with this anchor, get the controller to create content.
        // Otherwise (switching content), will change content when setting `selectedVirtualContent`.
        if node.childNodes.isEmpty, let contentNode = selectedContentController.renderer(renderer, nodeFor: faceAnchor) {
            node.addChildNode(contentNode)
        }
    }
    
    /// - Tag: ARFaceGeometryUpdate
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor == currentFaceAnchor,
            let contentNode = selectedContentController.contentNode,
            contentNode.parent == node
            else { return }
        
        selectedContentController.renderer(renderer, didUpdate: contentNode, for: anchor)
    }
}
