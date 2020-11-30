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

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // FACE DETECTION
    let numberOfFaces: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .orange
        label.font = UIFont(name: "Avenir-Heavy", size: 30)
        label.text = "No face"
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupTabBar()
        setupCamera()
        setupLabel()
        setupButtons()
    }
    
//    func setupTabBar() {
//        navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationItem.title = "Face Detection"
//        if #available(iOS 13.0, *) {
//            self.navigationController?.navigationBar.barTintColor = .systemBackground
//             navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.label]
//        } else {
//            // Fallback on earlier versions
//            self.navigationController?.navigationBar.barTintColor = .lightText
//            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
//        }
//        self.navigationController?.navigationBar.isHidden = false
//        self.setNeedsStatusBarAppearanceUpdate()
//        self.navigationItem.largeTitleDisplayMode = .automatic
//        self.navigationController?.navigationBar.barStyle = .default
//        if #available(iOS 13.0, *) {
//            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.label]
//        } else {
//            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
//        }
//        if #available(iOS 13.0, *) {
//            navigationController?.navigationBar.backgroundColor = .systemBackground
//        } else {
//            // Fallback on earlier versions
//            navigationController?.navigationBar.backgroundColor = .white
//        }
//        self.tabBarController?.tabBar.isHidden = false
//    }
    
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
    
    fileprivate func setupLabel() {
        view.addSubview(numberOfFaces)
        numberOfFaces.translatesAutoresizingMaskIntoConstraints = false
        let widthContraints =  NSLayoutConstraint(item: numberOfFaces, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200)
            
        let heightContraints = NSLayoutConstraint(item: numberOfFaces, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80)
        
        let xContraints = NSLayoutConstraint(item: numberOfFaces, attribute: NSLayoutConstraint.Attribute.bottomMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1, constant: -20)
        
        let yContraints = NSLayoutConstraint(item: numberOfFaces, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -200)
        
        NSLayoutConstraint.activate([heightContraints,widthContraints,xContraints,yContraints])
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
    

    
    let settings: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToSettings(_:)), for: .touchUpInside)
        let icon = UIImage(named: "icons8-settings-500")
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 10, right: 10)
        //button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private func setupButtons() {
        view.addSubview(settings)
        settings.translatesAutoresizingMaskIntoConstraints = false
        let widthContraints =  NSLayoutConstraint(item: settings, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80)
            
        let heightContraints = NSLayoutConstraint(item: settings, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80)
        
        let xContraints = NSLayoutConstraint(item: settings, attribute: NSLayoutConstraint.Attribute.bottomMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1, constant: -20)
        
        let yContraints = NSLayoutConstraint(item: settings, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -20)
        
        NSLayoutConstraint.activate([heightContraints,widthContraints,xContraints,yContraints])
        
    }
    
    //Settings Page Button
    @objc func buttonToSettings(_ sender: UIButton) {
       let controller = SettingsViewController()
       let navController = UINavigationController(rootViewController: controller)
       self.present(navController, animated: true, completion: nil)
    }
}

