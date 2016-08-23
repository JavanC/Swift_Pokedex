//
//  AppDelegate.swift
//  Pokedex
//
//  Created by Javan on 2016/8/16.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

let color1 = UIColor(hex: 0xDB2B39, alpha: 1)
let color2 = UIColor(hex: 0xFF4B3E, alpha: 1)
let color3 = UIColor(hex: 0x832232, alpha: 1)
let color4 = UIColor(hex: 0xFF7768, alpha: 1)
let color5 = UIColor(hex: 0xF6BD39, alpha: 1)
let color6 = UIColor(hex: 0x4B3B47, alpha: 1)
let color7 = UIColor(hex: 0xC3423F, alpha: 1)


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        configureAppearance()
        return true
    }
    
    func configureAppearance() {
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        
        let imageSize = CGSize(width: 1, height: 1)
        let shadowColor = color3
        let barColor = color2
        let backgroundImage = UIImage.imageWithColor(barColor, size: imageSize)
        UINavigationBar.appearance().setBackgroundImage(backgroundImage, forBarMetrics: .Default)
        
        let shadowImage = UIImage.imageWithColor(shadowColor, size: imageSize)
        UINavigationBar.appearance().shadowImage = shadowImage
    }
}

extension UIColor{
    // create color from hexadecimal input eg 0xFF0000 will be red
    convenience init(hex:UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension UIImage {
    // create image of solid color
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        CGContextFillRect(context, CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
