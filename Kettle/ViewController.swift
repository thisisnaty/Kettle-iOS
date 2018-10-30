//
//  ViewController.swift
//  Kettle
//
//  Created by Natalia Garcia on 10/29/18.
//  Copyright © 2018 Natalia Garcia. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var captureButton: CircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sharedInit()
    }
    
    func sharedInit() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                self.setupCaptureSession()
            
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) {
                    granted in
                    if granted {
                        self.setupCaptureSession()
                    }
                }
            
            case .denied:
                return
            
            case .restricted:
                return
        }
    }
    
    func setupCaptureButton() {
        let tapRecognizer = UITapGestureRecognizer()
        
    }
    
    func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        captureSession.beginConfiguration()

        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
        
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            captureSession.canAddInput(videoDeviceInput)
            else { return }
        captureSession.addInput(videoDeviceInput)
        
        let photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
        
        self.previewView.videoPreviewLayer.session = captureSession
        self.previewView.videoPreviewLayer.frame.size = self.previewView.frame.size
        self.previewView.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        captureSession.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

