//
//  RangeSlider.swift
//  Pokedex
//
//  Created by Javan on 2016/8/17.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSlider: UIControl {
    let trackLayer = RangeSliderTrackLayer()
    let currentThumbLayer = RangeSliderThumbLayer()
    var previousLocation = CGPoint()
    
    var minimunValue: Double = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    var maximunValue: Double = 40.0 {
        didSet {
            updateLayerFrames()
        }
    }
    var currentValue: Double = 20.0 {
        didSet {
            updateLayerFrames()
        }
    }
    var trackTintColor = UIColor(white: 0.9, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    var trackHighlightTintColor = UIColor(red: 0.0, green: 0.45, blue: 0.94, alpha: 1.0) {
        didSet {
           trackLayer.setNeedsDisplay()
        }
    }
    var thubTintColor = UIColor.whiteColor() {
        didSet {
            currentThumbLayer.setNeedsDisplay()
        }
    }
    
    var curvaceousness: CGFloat = 1.0 {
        didSet {
            trackLayer.setNeedsDisplay()
            currentThumbLayer.setNeedsDisplay()
        }
    }
    
    var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackLayer.rangeSlider = self
//        trackLayer.backgroundColor = UIColor.redColor().CGColor
        trackLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(trackLayer)
        
        currentThumbLayer.rangeSlider = self
        currentThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(currentThumbLayer)
        
//        updateLayerFrames()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        
        let currentThumbCenter = CGFloat(positionForValue(currentValue))
        currentThumbLayer.frame = CGRect(x: currentThumbCenter - thumbWidth / 2.0, y: 0, width: thumbWidth, height: thumbWidth)
        currentThumbLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    func positionForValue(value: Double) -> Double {
        return Double(bounds.width - thumbWidth) * (value - minimunValue) / (maximunValue - minimunValue) + Double(thumbWidth / 2)
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        previousLocation = touch.locationInView(self)
        
        // Hit test the thumb layers
        if currentThumbLayer.frame.contains(previousLocation) {
            currentThumbLayer.highlighted = true
        }
        return currentThumbLayer.highlighted
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let location = touch.locationInView(self)
        
        // 1. Determine by how much the user has dragged
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maximunValue - minimunValue) * deltaLocation / Double(bounds.width - bounds.height)
        
        previousLocation = location
        
        // 2. Update the value
        if currentThumbLayer.highlighted {
            currentValue += deltaValue
            currentValue = min(max(currentValue, minimunValue), maximunValue)
        }
        
        sendActionsForControlEvents(.ValueChanged)
        
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        currentThumbLayer.highlighted = false
    }
}
