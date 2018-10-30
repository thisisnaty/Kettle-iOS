//
//  CircleView.swift
//  Kettle
//
//  Created by Natalia Garcia on 10/29/18.
//  Copyright © 2018 Natalia Garcia. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    override var bounds: CGRect {
        didSet {
            sharedInit()
            setNeedsDisplay()
        }
    }
    
    private func sharedInit() {
        let size = self.frame.width
        self.layer.cornerRadius = size/2
        self.layer.bounds = CGRect(origin: self.bounds.origin,
                                   size: CGSize(width: size, height: size))
        self.frame = CGRect(origin: self.frame.origin,
                            size: CGSize(width: size, height: size))
    }
    
    func setBorderColor(_ color: UIColor) {
        self.layer.borderColor = color.cgColor
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
