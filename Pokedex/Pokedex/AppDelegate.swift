//
//  AppDelegate.swift
//  Pokedex
//
//  Created by Javan on 2016/8/16.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

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
        
        let imageSize = CGSize(width: 1, height: 1)
        let shadowColor = UIColor.lightGrayColor()
        let barColor = UIColor.redColor()
        let backgroundImage = UIImage.imageWithColor(barColor, size: imageSize)
        UINavigationBar.appearance().setBackgroundImage(backgroundImage, forBarMetrics: .Default)
        let shadowImage = UIImage.imageWithColor(shadowColor, size: imageSize)
        UINavigationBar.appearance().shadowImage = shadowImage
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
