//
//  RangeSliderThumbLayer.swift
//  Pokedex
//
//  Created by Javan on 2016/8/17.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit
import QuartzCore

class RulerSliderThumbLayer: CALayer {
    var highlighted: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    weak var rulerSlider: RulerSlider?
    
    override func drawInContext(ctx: CGContext) {
        if let slider = rulerSlider {
            let thumbFrame = bounds.insetBy(dx: 0, dy: 1.0)
            let cornerRadius = thumbFrame.height * 0.25
            let thumbPath = UIBezierPath()
            thumbPath.moveToPoint(CGPoint(x: 0, y: cornerRadius))
            thumbPath.addQuadCurveToPoint(CGPoint(x: cornerRadius, y: 0), controlPoint: CGPoint(x: 0, y: 0))
            thumbPath.addLineToPoint(CGPoint(x: thumbFrame.width - cornerRadius, y: 0))
            thumbPath.addQuadCurveToPoint(CGPoint(x: thumbFrame.width, y: cornerRadius), controlPoint: CGPoint(x: thumbFrame.width, y: 0))
            thumbPath.addLineToPoint(CGPoint(x: thumbFrame.width, y: thumbFrame.height * 0.66))
            thumbPath.addLineToPoint(CGPoint(x: thumbFrame.width / 2, y: thumbFrame.height))
            thumbPath.addLineToPoint(CGPoint(x: 0, y: thumbFrame.height * 0.66))
            thumbPath.addLineToPoint(CGPoint(x: 0, y: cornerRadius))
                        
            // Fill - tith a subtle shadow
//            let shadowColor = UIColor.lightGrayColor()
//            CGContextSetShadowWithColor(ctx, CGSize(width: 0.0, height: 1.0), 1.0, color3.CGColor)
            CGContextSetFillColorWithColor(ctx, slider.thubTintColor.CGColor)
            CGContextAddPath(ctx, thumbPath.CGPath)
            CGContextFillPath(ctx)
            
            // Outline
            CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor().CGColor)
            CGContextSetLineWidth(ctx, 2.0)
            CGContextAddPath(ctx, thumbPath.CGPath)
            CGContextStrokePath(ctx)
            
            if highlighted {
                CGContextSetFillColorWithColor(ctx, UIColor(white: 0.0, alpha: 0.1).CGColor)
                CGContextAddPath(ctx, thumbPath.CGPath)
                CGContextFillPath(ctx)
            }
        }
    }
}
