//
//  File.swift
//  Kettle
//
//  Created by Natalia Garcia on 10/29/18.
//  Copyright © 2018 Natalia Garcia. All rights reserved.
//

import UIKit
import AVFoundation
class PreviewView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
