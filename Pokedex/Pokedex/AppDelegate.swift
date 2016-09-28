//
//  AppDelegate.swift
//  Pokedex
//
//  Created by Javan on 2016/8/16.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

enum Team : Int { case Instinct, Mystic, Valor }
enum Lang : Int { case English, Chinese, Austrian }
var userTeam = Team.Instinct
var userLang = Lang.English
var hasTeach = false
var isShowFavorite = false
var favoritePokemonData = [Pokemon]()
func teamColor(alpha alpha: CGFloat) -> UIColor {
    switch userTeam {
    case .Instinct: return UIColor(hex: 0xF9CB11, alpha: alpha)
    case .Mystic:   return UIColor(hex: 0x0091E5, alpha: alpha)
    case .Valor:    return UIColor(hex: 0xFF7768, alpha: alpha)
    }
}
func teamImage() -> UIImage {
    switch userTeam {
    case .Instinct: return UIImage(named: "team-instinct")!
    case .Mystic:   return UIImage(named: "team-mystic")!
    case .Valor:    return UIImage(named: "team-valor")!
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        loadUserData()
        configureAppearance()
        return true
    }
    
    func loadUserData() {
        let defaults = NSUserDefaults.standardUserDefaults()
        userTeam = Team(rawValue: defaults.integerForKey("userTeam"))!
        userLang = Lang(rawValue: defaults.integerForKey("userLang"))!
        hasTeach = defaults.boolForKey("hasTeach")
        
        // load favorite data
        if let loadDatas = NSUserDefaults.standardUserDefaults().objectForKey("favoritePokemonData") as? [[String:AnyObject]] {
            for data in loadDatas {
                var pokemon = pokemonData[data["pokemonDataIndex"] as! Int]
                pokemon.level = data["level"] as! Double
                pokemon.cp = data["cp"] as! Double
                pokemon.hp = data["hp"] as! Int
                pokemon.indiAtk = data["indiAtk"] as! Double
                pokemon.indiDef = data["indiDef"] as! Double
                pokemon.indiSta = data["indiSta"] as! Double
                pokemon.fastAttackNumber = data["fastAttackNumber"] as! Int
                pokemon.chargeAttackNumber = data["chargeAttackNumber"] as! Int
                favoritePokemonData.append(pokemon)
            }
        }
    }
    
    func configureAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().opaque = false
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

extension UILabel{
    // require label height
    func requiredHeight() -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.frame.width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.height
    }
    // require label size from text and font
    func textSize(text: String, font: UIFont) -> CGSize {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.frame.width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.size
    }
}

extension UIImage {
    // creat image with label
    class func imageWithLabel(label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UISegmentedControl {
    // replace segments title
    func replaceSegments(segments: Array<String>) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegmentWithTitle(segment, atIndex: self.numberOfSegments, animated: false)
        }
    }
}
