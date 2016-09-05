//
//  RangeSliderTrackLayer.swift
//  Pokedex
//
//  Created by Javan on 2016/8/17.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit
import QuartzCore

class RulerSliderTrackLayer: CALayer {
    weak var rulerSlider: RulerSlider?

    override func drawInContext(ctx: CGContext) {
        if let slider = rulerSlider {
            // Clip
            let number = slider.maximunValue - slider.minimunValue
            let graduationWidth: CGFloat = 1.0
            let graduationPosition = (frame.width - graduationWidth * 2) / CGFloat(number)
            
            for i in 0...Int(number) {
                var height = CGFloat()
                var y = CGFloat()
                if i == 0 || (i + 2) % 10 == 0 {
                    height = frame.height
                    y = 0
                } else if (i + 2) % 5 == 0 {
                    height = frame.height * 0.75
                    y = frame.height * 0.25
                } else {
                    height = frame.height * 0.5
                    y = frame.height * 0.5
                }
                let rect = CGRect(x: CGFloat(i) * graduationPosition, y: y, width: graduationWidth, height: height)
                let path = UIBezierPath(rect: rect)
                CGContextAddPath(ctx, path.CGPath)
            }
            
            // Fill the track
            CGContextSetFillColorWithColor(ctx, slider.trackTintColor.CGColor)
            CGContextFillPath(ctx)
        }
    }
}
