//
//  RangeSliderTrackLayer.swift
//  Pokedex
//
//  Created by Javan on 2016/8/17.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSliderTrackLayer: CALayer {
    weak var rangeSlider: RangeSlider?
    
    override func drawInContext(ctx: CGContext) {
        if let slider = rangeSlider {
            // Clip
            let cornerRadius = bounds.height * slider.curvaceousness / 2.0
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            CGContextAddPath(ctx, path.CGPath)
            
            // Fill the track
            CGContextSetFillColorWithColor(ctx, slider.trackTintColor.CGColor)
            CGContextAddPath(ctx, path.CGPath)
            CGContextFillPath(ctx)
            
            if slider.showPoint {
                let number = slider.maximunValue - slider.minimunValue
                let radius = bounds.height / 2
                let gap = (frame.width - radius * 2) / CGFloat(number)
                for i in 0...Int(number) {
                    let rect = CGRect(x: CGFloat(i) * gap, y: 0, width: radius * 2, height: radius * 2)
                    let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
                    CGContextAddPath(ctx, path.CGPath)
                }
                CGContextSetFillColorWithColor(ctx, UIColor(hex: 0x000000, alpha: 0.3).CGColor)
                CGContextFillPath(ctx)
            }
        }
    }
}
