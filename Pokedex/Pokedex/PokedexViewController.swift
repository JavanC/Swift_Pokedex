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
    }
    
    override func viewWillAppear(animated: Bool) {
        updateTeamColor()
        updateLanguage()
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
        self.performSegueWithIdentifier("toSettingVController", sender: self)
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
            title = "Pokedex"
        case .Chinese, .Austrian:
            title = "圖鑒"
        }
    }
}

extension PokedexViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonData.count
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
