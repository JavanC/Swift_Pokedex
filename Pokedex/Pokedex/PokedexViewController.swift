//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by Javan on 2016/8/16.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        if !hasTeach {
            let alertController = UIAlertController(title: "Welcome!!", message: "You can choose your team and language, or later you can set in the \"Setting\" inside.", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Later", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            let okAction = UIAlertAction(title: "Choose my team", style: .Default, handler: { (action:UIAlertAction!) -> Void in
                self.pushToSettingController()
            })
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        updateTeamColor()
        updateLanguage()
        checkRateUs()
    }
    
    private func configureView() {
        // Initial navigation bar
        self.navigationController?.navigationBar.translucent = false
        let navigationBarFrame = self.navigationController!.navigationBar.frame
        let shadowView = UIView(frame: navigationBarFrame)
        shadowView.backgroundColor = UIColor.whiteColor()
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius =  4
        shadowView.layer.position = CGPoint(x: navigationBarFrame.width / 2, y:  -navigationBarFrame.height / 2)
        self.view.addSubview(shadowView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting"), style: .Plain, target: self, action: #selector(pushToSettingController))
    }
    
    func pushToSettingController() {
        self.performSegueWithIdentifier("toSettingViewController", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? UICollectionViewCell {
            let indexPath = collectionView.indexPathForCell(cell)!
            let pokemon = pokemonData[indexPath.row]
            let controller = segue.destinationViewController as! PokemonViewController
            controller.pokemon = pokemon
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func checkRateUs() {
        var openTimes = NSUserDefaults.standardUserDefaults().integerForKey("openTimes")
        let noMoreRate = NSUserDefaults.standardUserDefaults().boolForKey("noMoreRate")
        if !hasTeach { openTimes = 15 }
        openTimes += 1
        print("open time: \(openTimes), no more rate: \(noMoreRate)")
        if openTimes % 25 == 0 && !noMoreRate{
            var title = "", message = "", action1Title = "", action2Title = "", action3Title = ""
            switch userLang {
            case .English:
                title = "Feel useful?"
                message = "Woule you mind rating this app?"
                action1Title = "No, Thanks"
                action2Title = "Remind Me Later"
                action3Title = "Rate It Now"
            case .Chinese, .Austrian:
                title = "覺得好用?"
                message = "希望可以花您一點點時間評分:D"
                action1Title = "不，謝謝"
                action2Title = "稍後再提醒我"
                action3Title = "我要評分"
            }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let action1 = UIAlertAction(title: action1Title, style: .Default) { (action: UIAlertAction!) -> Void in
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "noMoreRate")
            }
            alertController.addAction(action1)
            let action2 = UIAlertAction(title: action2Title, style: .Default, handler: nil)
            alertController.addAction(action2)
            let action3 = UIAlertAction(title: action3Title, style: .Cancel) { (action: UIAlertAction!) -> Void in
                let appID = "1148520008"
                if let checkURL = NSURL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8") {
                    if UIApplication.sharedApplication().openURL(checkURL) {
                        print("url successfully opened")
                    }
                } else {
                    print("invalid url")
                }
            }
            alertController.addAction(action3)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        NSUserDefaults.standardUserDefaults().setInteger(openTimes, forKey: "openTimes")
    }
    
    // update team and language
    @IBOutlet weak var backgroundImage: UIImageView!
    func updateTeamColor() {
        switch userTeam {
        case .Instinct:
            backgroundImage.image = UIImage(named: "team-instinct")
            collectionView.backgroundColor = colorBGY
            self.navigationController?.navigationBar.barTintColor = colorY
        case .Mystic:
            backgroundImage.image = UIImage(named: "team-mystic")
            collectionView.backgroundColor = colorBGB
            self.navigationController?.navigationBar.barTintColor = colorB
        case .Valor:
            backgroundImage.image = UIImage(named: "team-valor")
            collectionView.backgroundColor = colorBGR
            self.navigationController?.navigationBar.barTintColor = colorR
        }
    }
    func updateLanguage() {
        switch userLang {
        case .English:
            title = "Poke Booklet"
            navigationItem.backBarButtonItem?.title = "Back"
        case .Chinese, .Austrian:
            title = "陣營手冊"
            navigationItem.backBarButtonItem?.title = "返回"
        }
    }
}

extension PokedexViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonData.count
    }
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PokedexCollectionViewCell {
            cell.imageView.frame = CGRect(x: 5, y: 5, width: 70, height: 70)
        }
    }
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PokedexCollectionViewCell {
            cell.imageView.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath)
        if let cell = cell as? PokedexCollectionViewCell {
            cell.pokemon = pokemonData[indexPath.row]
        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        
        print(UIScreen.mainScreen().bounds.size)
        
        let frameWidth = UIScreen.mainScreen().bounds.size.width
        let cellNumber = CGFloat(Int(frameWidth / 80))
        let inset = (frameWidth % 80) / (cellNumber + 1)
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}
