//
//  BorderedButton.swift
//  OnTheMap
//
//  Created by Layne Faler on 7/5/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

import UIKit

// MARK: - BorderedButton: Button

@IBDesignable
class BorderedButton: UIButton {
    
    // MARK: IBInspectable
    
    @IBInspectable var backingColor: UIColor = UIColor.clearColor() {
        didSet {
            backgroundColor = backingColor
        }
    }
    
    @IBInspectable var highlightColor: UIColor = UIColor.clearColor() {
        didSet {
            if state == .Highlighted {
                backgroundColor = highlightColor
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 4.0 {
        didSet {
            layer.masksToBounds = true
            layer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: Tracking
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent: UIEvent?) -> Bool {
        backgroundColor = highlightColor
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        backgroundColor = backingColor
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        backgroundColor = backingColor
    }
}
