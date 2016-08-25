//
//  RangeSlider.swift
//  Pokedex
//
//  Created by Javan on 2016/8/17.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit
import QuartzCore

class RulerSlider: UIControl {
    let trackLayer = RulerSliderTrackLayer()
    let currentThumbLayer = RulerSliderThumbLayer()
    var previousLocation = CGPoint()
    
    var minimunValue: Double = 2.0 {
        didSet {
            updateLayerFrames()
        }
    }
    var maximunValue: Double = 80.0 {
        didSet {
            updateLayerFrames()
        }
    }
    var currentValue: Double = 40.0 {
        didSet {
            updateLayerFrames()
        }
    }
    var trackTintColor = UIColor.whiteColor() {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    var thubTintColor = colorR {
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
        trackLayer.rulerSlider = self
        trackLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(trackLayer)
        currentThumbLayer.rulerSlider = self
        currentThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(currentThumbLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = CGRect(x: 0, y: frame.height / 2, width: frame.width + 1, height: frame.height / 2)
        trackLayer.setNeedsDisplay()
        
        let currentThumbCenter = CGFloat(positionForValue(currentValue))
        currentThumbLayer.frame = CGRect(x: currentThumbCenter - thumbWidth / 2.0, y: 0, width: thumbWidth, height: thumbWidth)
        currentThumbLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    func positionForValue(value: Double) -> Double {
        let inset = maximunValue - minimunValue == 0 ? 1 : maximunValue - minimunValue
        return Double(bounds.width) * (value - minimunValue) / inset
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
        if Int(deltaValue) == 0 { return true }
        
        previousLocation = location
        
        // 2. Update the value
        if currentThumbLayer.highlighted {
            currentValue += Double(Int(deltaValue))
            currentValue = min(max(currentValue, minimunValue), maximunValue)
        }
        
        sendActionsForControlEvents(.ValueChanged)
        
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        currentThumbLayer.highlighted = false
    }
}
