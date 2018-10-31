//
//  CameraView.swift
//  Kettle
//
//  Created by Natalia Garcia on 10/29/18.
//  Copyright © 2018 Natalia Garcia. All rights reserved.
//

import AVFoundation
import Foundation
import RxCocoa
import RxSwift
import UIKit

class CameraView: CustomView {
    private let disposeBag = DisposeBag()
    @IBOutlet weak var captureButton: CircleView!
    @IBOutlet weak var previewView: PreviewView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
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
    
    private func setupTapCaptureButton(photoOutput: AVCapturePhotoOutput, photoSettings: AVCapturePhotoSettings, captureProcessor: PhotoCaptureProcessor) {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.rx.event
            .bind(onNext: { _ in
                let uniqueSettings = AVCapturePhotoSettings.init(from: photoSettings)
                photoOutput.capturePhoto(with: uniqueSettings, delegate: captureProcessor)
            }).disposed(by: disposeBag)
        
        self.captureButton.addGestureRecognizer(tapRecognizer)
    }
    
    private func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
        
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            captureSession.canAddInput(videoDeviceInput)
            else { return }
        captureSession.addInput(videoDeviceInput)
        
        let photoOutput = AVCapturePhotoOutput()
        let photoSettings: AVCapturePhotoSettings
        if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
            photoSettings = AVCapturePhotoSettings(format:
                [AVVideoCodecKey: AVVideoCodecType.hevc])
        } else {
            photoSettings = AVCapturePhotoSettings()
        }
        photoSettings.flashMode = .auto
        photoSettings.isAutoStillImageStabilizationEnabled = photoOutput.isStillImageStabilizationSupported
        let captureProcessor = PhotoCaptureProcessor()
        self.setupTapCaptureButton(photoOutput: photoOutput, photoSettings: photoSettings, captureProcessor: captureProcessor)
        
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
        
        self.previewView.videoPreviewLayer.session = captureSession
        self.previewView.videoPreviewLayer.frame.size = self.previewView.frame.size
        self.previewView.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        captureSession.startRunning()
    }
}

class PhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        print(imageData?.base64EncodedString())
    }
}
