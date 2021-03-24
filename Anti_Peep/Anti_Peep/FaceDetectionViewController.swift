//
//  FaceDetectionViewController.swift
//  Anti_Peep
//
//  Created by Quentin Roy-Foster on 2020-10-12.
//  Copyright © 2020 XQProductions. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Vision
import Darwin

class FaceDetectionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
    var brightToggleIsOn = true
    var offToggleIsOn = true
    
    let numberOfFaces: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .orange
        label.font = UIFont(name: "Avenir-Heavy", size: 30)
        label.text = "No face"
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupCamera()
        setupLabel()
    }
    
    func setupTabBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Face Detection"
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.barTintColor = .systemBackground
             navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.label]
        } else {
            // Fallback on earlier versions
            self.navigationController?.navigationBar.barTintColor = .lightText
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
        }
        self.navigationController?.navigationBar.isHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barStyle = .default
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.label]
        } else {
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
        }
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.backgroundColor = .white
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func setupCamera() {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    fileprivate func setupLabel() {
        view.addSubview(numberOfFaces)
        numberOfFaces.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        numberOfFaces.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        numberOfFaces.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        numberOfFaces.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }
            
            DispatchQueue.main.async {
                if let results = req.results {
                    self.numberOfFaces.text = "\(results.count) face(s)"
                    if results.count > 0 { UIScreen.main.brightness = CGFloat(0) }
                    else { UIScreen.main.brightness = CGFloat(1) }
//                    if results.count > 0 {
//                        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
//                    }
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
    
    
    func toggleBrightness(){
        UIScreen.main.brightness = CGFloat(0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIScreen.main.brightness = CGFloat(1)
        }
    }
    
    func exitApplication(){
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    
}

//extension FaceDetectionViewController: settingsToggleDelegate {
//    
//    func toggleBrightnessReaction(isOn: Bool) {
//        brightToggleIsOn = isOn
//        
//    }
//    func toggleExitAppReaction(isOn: Bool) {
//        offToggleIsOn = isOn
//    }
//}
