//
//  ViewController.swift
//  Anti_Peep
//
//  Created by Quentin Roy-Foster on 2020-09-28.
//  Copyright © 2020 XQProductions. All rights reserved.
//
import Foundation
import UIKit
import AVKit
import Vision
import Darwin
import AVFoundation


class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // --------------------------------------------------
    // ----------------- ADMIN SECTION -----------------
    // --------------------------------------------------
    
    private let captureSession = AVCaptureSession()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var drawings: [CAShapeLayer] = []
    
    
    override func viewDidLoad() {
        //call the parent function
        super.viewDidLoad()
       // self.addCameraInput()
        //self.showCameraFeed()
        //self.getCameraFrames()
       // self.captureSession.startRunning()
        
        //establish the capture session and add label
        setupCamera()
        setupLabel()
        
        //setup buttons and toggle
        setupButtons()
        setupToggle()
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            self.previewLayer.frame = self.view.frame
        }
    
    // --------------------------------------------------
    // ----------------- CAMERA SECTION -----------------
    // --------------------------------------------------
    
    fileprivate func setupCamera() {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high

        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)

        captureSession.startRunning()

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame

        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    // LANDMARK DETECTION SECTION
    
    // CAPTURE OUTPUT FOR LANDMARK DETECTION
//    func captureOutput(
//            _ output: AVCaptureOutput,
//            didOutput sampleBuffer: CMSampleBuffer,
//            from connection: AVCaptureConnection) {
//
//            guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//                debugPrint("unable to get image from sample buffer")
//                return
//            }
//            self.detectFace(in: frame)
//        }
    
    
    private func addCameraInput() {
            guard let device = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
                mediaType: .video,
                position: .front).devices.first else {
                    fatalError("No back camera device found, please make sure to run SimpleLaneDetection in an iOS device and not a simulator")
            }
            let cameraInput = try! AVCaptureDeviceInput(device: device)
            self.captureSession.addInput(cameraInput)
        }
    
    private func showCameraFeed() {
            self.previewLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = self.view.frame
        }
    
    private func getCameraFrames() {
            self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
            self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
            self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
            self.captureSession.addOutput(self.videoDataOutput)
            guard let connection = self.videoDataOutput.connection(with: AVMediaType.video),
                connection.isVideoOrientationSupported else { return }
            connection.videoOrientation = .portrait
        }
    
    private func detectFace(in image: CVPixelBuffer) {
            let faceDetectionRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, error: Error?) in
                DispatchQueue.main.async {
                    if let results = request.results as? [VNFaceObservation] {
                        self.handleFaceDetectionResults(results)
                    } else {
                        self.clearDrawings()
                    }
                }
            })
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
            try? imageRequestHandler.perform([faceDetectionRequest])
        }
    
    private func handleFaceDetectionResults(_ observedFaces: [VNFaceObservation]) {
            
            self.clearDrawings()
            let facesBoundingBoxes: [CAShapeLayer] = observedFaces.flatMap({ (observedFace: VNFaceObservation) -> [CAShapeLayer] in
                let faceBoundingBoxOnScreen = self.previewLayer.layerRectConverted(fromMetadataOutputRect: observedFace.boundingBox)
                let faceBoundingBoxPath = CGPath(rect: faceBoundingBoxOnScreen, transform: nil)
                let faceBoundingBoxShape = CAShapeLayer()
                faceBoundingBoxShape.path = faceBoundingBoxPath
                faceBoundingBoxShape.fillColor = UIColor.clear.cgColor
                faceBoundingBoxShape.strokeColor = UIColor.green.cgColor
                var newDrawings = [CAShapeLayer]()
                newDrawings.append(faceBoundingBoxShape)
                if let landmarks = observedFace.landmarks {
                    newDrawings = newDrawings + self.drawFaceFeatures(landmarks, screenBoundingBox: faceBoundingBoxOnScreen)
                }
                return newDrawings
            })
            facesBoundingBoxes.forEach({ faceBoundingBox in self.view.layer.addSublayer(faceBoundingBox) })
            self.drawings = facesBoundingBoxes
        }
    
    private func clearDrawings() {
            self.drawings.forEach({ drawing in drawing.removeFromSuperlayer() })
        }
    
    private func drawFaceFeatures(_ landmarks: VNFaceLandmarks2D, screenBoundingBox: CGRect) -> [CAShapeLayer] {
            var faceFeaturesDrawings: [CAShapeLayer] = []
            if let leftEye = landmarks.leftEye {
                let eyeDrawing = self.drawEye(leftEye, screenBoundingBox: screenBoundingBox)
                faceFeaturesDrawings.append(eyeDrawing)
            }
            if let rightEye = landmarks.rightEye {
                let eyeDrawing = self.drawEye(rightEye, screenBoundingBox: screenBoundingBox)
                faceFeaturesDrawings.append(eyeDrawing)
            }
            // draw other face features here
            return faceFeaturesDrawings
        }
    
    private func drawEye(_ eye: VNFaceLandmarkRegion2D, screenBoundingBox: CGRect) -> CAShapeLayer {
            let eyePath = CGMutablePath()
            let eyePathPoints = eye.normalizedPoints
                .map({ eyePoint in
                    CGPoint(
                        x: eyePoint.y * screenBoundingBox.height + screenBoundingBox.origin.x,
                        y: eyePoint.x * screenBoundingBox.width + screenBoundingBox.origin.y)
                })
            eyePath.addLines(between: eyePathPoints)
            eyePath.closeSubpath()
            let eyeDrawing = CAShapeLayer()
            eyeDrawing.path = eyePath
            eyeDrawing.fillColor = UIColor.clear.cgColor
            eyeDrawing.strokeColor = UIColor.green.cgColor
            
            return eyeDrawing
        }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // captureOutput function for normal Vision face detection
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let request = VNDetectFaceRectanglesRequest { (req, err) in
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }
            DispatchQueue.main.async {
                if let results = req.results {
                    if self.antipeep == true {
                        self.faceCountFD.text = "\(results.count) face(s)"
//                        if results.count > 0 { UIScreen.main.brightness = CGFloat(0) }
//                        else { UIScreen.main.brightness = CGFloat(1) }
    //                    if results.count > 0 {
    //                        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    //                    }
                    }
                }
            }
        }
        DispatchQueue.global(qos: .userInteractive).async {
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            do {
                try handler.perform([request])
            } catch let reqErr {
                print("Failed to perform request:", reqErr)
            }
        }
    }
    
    // captureOutput function for CoreML
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//            // load our CoreML Pokedex model
//            guard let model = try? VNCoreMLModel(for: GazeCNN().model) else {
//                return }
//            // run an inference with CoreML
//            let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
//                // grab the inference results
//                guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
//
//                // grab the highest confidence result
//                guard let Observation = results.first else { return }
//
//                // create the label text components
//                let predclass = "\(Observation.identifier)"
//                let predconfidence = String(format: "%.02f%", Observation.confidence * 100)
//                // set the label text
//                DispatchQueue.main.async(execute: {
//                    self.faceCountFD.text = "\(predclass) \(predconfidence)"
//                })
//            }
//
//            // create a Core Video pixel buffer which is an image buffer that holds pixels in main memory
//            // Applications generating frames, compressing or decompressing video, or using Core Image
//            // can all make use of Core Video pixel buffers
//            guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//
//            // execute the request
//            try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
//        }
    
    // --------------------------------------------------
    // ------------------- UI SECTION -------------------
    // --------------------------------------------------
    
    // ------------- UI Components Section --------------
    
    // Face Detection Face Count UI Label
    var faceCountFD: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightText
        label.font = UIFont(name: "Avenir-Heavy", size: 30)
        return label
    }()
    
    // CoreML Face Count UI Label
    let faceCountML: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Label"
            label.font = label.font.withSize(30)
            return label
        }()
    
    //antipeep set to true when
    //face detection active
    var antipeep = true
    
    
    // settings page button
    let settings: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToSettings(_:)), for: .touchUpInside)
        let icon = UIImage(systemName: "gear")
        let largeConfig = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        let largeBolt = UIImage(systemName: "gear", withConfiguration: largeConfig)
        button.setImage(largeBolt, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
        
    }()
    

    
   // toggle switch used to
   // turn anti-peep on/off
    lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.setOn(true, animated: false)
        toggle.onTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(switchToOff), for: .valueChanged)
        return toggle
    }()
    
    // ------------- UI Setup Functions -------------
    
    // helper function that sets up the UI label
    // adds the label as a subview and sets its constraints
    fileprivate func setupLabel() {
        view.addSubview(faceCountFD)
        faceCountFD.translatesAutoresizingMaskIntoConstraints = false
        let widthContraints =  NSLayoutConstraint(item: faceCountFD, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200)
            
        let heightContraints = NSLayoutConstraint(item: faceCountFD, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80)
        
        let xContraints = NSLayoutConstraint(item: faceCountFD, attribute: NSLayoutConstraint.Attribute.bottomMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1, constant: -20)
        
        let yContraints = NSLayoutConstraint(item: faceCountFD, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -150)
        
        NSLayoutConstraint.activate([heightContraints,widthContraints,xContraints,yContraints])
    }
    
    // helper function that sets up the settings button
    // adds the button as a subview and sets its constraints
    private func setupButtons() {
        view.addSubview(settings)
        settings.translatesAutoresizingMaskIntoConstraints = false
        let widthContraints =  NSLayoutConstraint(item: settings, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80)
            
        let heightContraints = NSLayoutConstraint(item: settings, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80)
        
        let xContraints = NSLayoutConstraint(item: settings, attribute: NSLayoutConstraint.Attribute.bottomMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1, constant: -20)
        
        let yContraints = NSLayoutConstraint(item: settings, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -15)
        
        NSLayoutConstraint.activate([heightContraints,widthContraints,xContraints,yContraints])
        
    }
    
    // helper function that sets up the anti-peep toggle
    // adds the toggle as a subview and sets its constraints
    private func setupToggle() {
        view.addSubview(toggle)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        let widthContraints =  NSLayoutConstraint(item: toggle, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80)
            
        let heightContraints = NSLayoutConstraint(item: toggle, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80)
        
        let xContraints = NSLayoutConstraint(item: toggle, attribute: NSLayoutConstraint.Attribute.bottomMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1, constant: -660)
        
        let yContraints = NSLayoutConstraint(item: toggle, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 10)
        
        NSLayoutConstraint.activate([heightContraints,widthContraints,xContraints,yContraints])
        
    }
    
    // ------------- UI Component Functionality -------------
    
    // settings page navigation function
    @objc func buttonToSettings(_ sender: UIButton) {
       let controller = SettingsPageViewController()
       let navController = UINavigationController(rootViewController: controller)
       self.present(navController, animated: true, completion: nil)
    }
    
    // toggle face detection function
    @objc func switchToOff(_ sender: UISwitch) {
        if toggle.isOn == true {
            antipeep = true
            faceCountFD.textColor = .black
            faceCountFD.font = UIFont(name: "Avenir-Heavy", size: 30)
        }
        else if toggle.isOn == false {
            antipeep = false
            faceCountFD.textColor = .red
            faceCountFD.text = "Face Detection off!"
            faceCountFD.font = UIFont(name: "Avenir-Heavy", size: 22)
        }
    }
    
}

