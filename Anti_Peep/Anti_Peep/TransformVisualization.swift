/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Displays coordinate axes visualizing the tracked face pose (and eyes in iOS 12).
*/

import ARKit
import SceneKit

protocol eyeDataDelegate {
    func getLookAtPoint(lookAtPoint: simd_float3)
}

class TransformVisualization: NSObject, VirtualContentController {
    
    var delegate: eyeDataDelegate?
    
    var matrix: simd_float4x4?
    
    var contentNode: SCNNode?
    
    // Load multiple copies of the axis origin visualization for the transforms this class visualizes.
    lazy var rightEyeNode = SCNReferenceNode(named: "coordinateOrigin")
    lazy var leftEyeNode = SCNReferenceNode(named: "coordinateOrigin")
    
    /// - Tag: ARNodeTracking
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // This class adds AR content only for face anchors.
        guard anchor is ARFaceAnchor else { return nil }
        
        // Load an asset from the app bundle to provide visual content for the anchor.
        contentNode = SCNReferenceNode()
        
        self.addEyeTransformNodes()
        
        // Provide the node to ARKit for keeping in sync with the face anchor.
        return contentNode
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor){
        guard #available(iOS 12.0, *), let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        update(withFaceAnchor: faceAnchor)
        
        
        rightEyeNode.simdTransform = faceAnchor.rightEyeTransform
        leftEyeNode.simdTransform = faceAnchor.leftEyeTransform
        
        //let text = TransformViewController.faceCountFD
        //TransformViewController().faceCountFD.text = "from other file"
        //faceCountFD.text = "\(results.count) face(s)"
    }
    
    func update(withFaceAnchor anchor: ARFaceAnchor){
        delegate?.getLookAtPoint(lookAtPoint: anchor.lookAtPoint)
        //-0.028 - 0.028
        if (anchor.lookAtPoint.x > -0.050 && anchor.lookAtPoint.x < 0.050 && anchor.lookAtPoint.y > -0.15 && anchor.lookAtPoint.y < 0.15){
            print("looking")
        }
        else {
            print("NOT LOOKING")
        }
        
        //print(anchor.lookAtPoint)
        matrix = anchor.rightEyeTransform
        //print(anchor.leftEyeTransform)
    }
    
    func addEyeTransformNodes() {
        guard #available(iOS 12.0, *), let anchorNode = contentNode else { return }
        
        // Scale down the coordinate axis visualizations for eyes.
        rightEyeNode.simdPivot = simd_float4x4(diagonal: SIMD4(3,3,3,1))
        leftEyeNode.simdPivot = simd_float4x4(diagonal: SIMD4(3,3,3,1))
        
        anchorNode.addChildNode(rightEyeNode)
        anchorNode.addChildNode(leftEyeNode)
    }

}
