//
//  BattleOpponentViewController.swift
//  Poke Booklet
//
//  Created by Javan.Chen on 2016/9/26.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

class BattleOpponentViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        
    }
    
    // update team and language
    func updateTeamColor() {
        switch userTeam {
        case .Instinct:
            break
        case .Mystic:
            break
        case .Valor:
           break
        }
    }
    func updateLanguage() {
        switch userLang {
        case .English:
           break
        case .Chinese, .Austrian:
            break
        }
    }
}

extension BattleOpponentViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonData.count
    }
//    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
//        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PokedexCollectionViewCell {
//            cell.imageView.frame = CGRect(x: 5, y: 5, width: 70, height: 70)
//        }
//    }
//    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
//        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PokedexCollectionViewCell {
//            cell.imageView.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
//        }
//    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        cell.backgroundView?.backgroundColor = UIColor.lightGrayColor()
        
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath)
//        if let cell = cell as? PokedexCollectionViewCell {
//            cell.pokemon = isShowFavorite ? favoritePokemonData[indexPath.row] : pokemonData[indexPath.row]
//            if isShowFavorite {
//                cell.pokeNumber.text = "CP\(Int(favoritePokemonData[indexPath.row].cp))"
//            }
//        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        
//        print(UIScreen.mainScreen().bounds.size)
        
        let frameWidth = UIScreen.mainScreen().bounds.size.width
        let cellNumber = CGFloat(Int(frameWidth / 50))
        let inset = (frameWidth % 50) / (cellNumber + 1)
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}
