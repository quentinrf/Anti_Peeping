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
    
    var brightToggleIsOn = true
    var offToggleIsOn = true
    
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
        setupTitle()
    }
    
    func setupTitle() {
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "Face Detection"
        self.navigationController?.navigationBar.barTintColor = .systemBlue
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
                        if results.count > 0 {
                            
//                            if self.brightToggleIsOn == true
//                            { self.toggleBrightness() }
                        }
                        
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
        
        let xContraints = NSLayoutConstraint(item: toggle, attribute: NSLayoutConstraint.Attribute.bottomMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1, constant: -590)
        
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

extension ViewController: settingsToggleDelegate {
    
    func toggleBrightnessReaction() {
        brightToggleIsOn.toggle()
        print(brightToggleIsOn)
    }
    func toggleExitAppReaction(isOn: Bool) {
        offToggleIsOn = isOn
        print(offToggleIsOn)
    }
}
