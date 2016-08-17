//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by Javan on 2016/8/16.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //configureView()
        print(UIScreen.mainScreen().bounds.size)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! PokedexCollectionViewCell
        
        print(cell.frame.size)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        let frameWidth = UIScreen.mainScreen().bounds.size.width
        let cellNumber = CGFloat(Int(frameWidth / 80))
        print(cellNumber)
        let inset = (frameWidth % 80) / (cellNumber + 1)
        print(inset)
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}

