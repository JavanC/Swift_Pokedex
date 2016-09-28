//
//  BattleOpponentViewController.swift
//  Poke Booklet
//
//  Created by Javan.Chen on 2016/9/26.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

protocol OpponentDelegate{
    func sendOpponentData(opponent: Pokemon)
}

class BattleOpponentViewController: UIViewController {
    
    @IBOutlet weak var cpTextField: UITextField!
    @IBOutlet weak var OpponentImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var battleButton: UIButton!

    var opponent: Pokemon!
    var delegate : OpponentDelegate?
    
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
        
        // Initial opponent
        opponent = pokemonData[24]
        opponent.level = 20
        opponent.cp = 500
        opponent.hp = 50
        
        // cpTextField
        cpTextField.keyboardType = .NumberPad
        
        // collection view
        collectionView.backgroundColor = teamColor(alpha: 0.04)
        collectionView.allowsMultipleSelection = false
        let firstIndexPath = NSIndexPath(forItem: 24, inSection: 0)
        collectionView.selectItemAtIndexPath(firstIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.Left)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        calculateOpponentLevel()
        super.touchesBegan(touches, withEvent: event)
    }
    
    func calculateOpponentLevel() {
        // get cp
        var cp: Double = 10
        if let str = cpTextField.text {
            if str == "" {
                cp = 500
            } else {
                cp = Double(str)!
            }
        }
        // get level
        var posibleLevel = [Double]()
        for level in 2...80 {
            opponent.level = Double(level) / 2
            if cp >= opponent.minCp && cp <= opponent.maxCp {
                posibleLevel.append(opponent.level)
            }
        }
        // set opponent
        if posibleLevel.count != 0 {
            opponent.level = posibleLevel.last!
            opponent.cp = cp
            battleButton.enabled = true
            battleButton.backgroundColor = teamColor(alpha: 1)
        } else {
            battleButton.enabled = false
            battleButton.backgroundColor = UIColor.lightGrayColor()
        }
    }
    
    @IBAction func battleButtonTouchUp(sender: AnyObject) {
        delegate?.sendOpponentData(opponent)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // update team and language
    func updateTeamColor() {
        navigationController?.navigationBar.barTintColor = teamColor(alpha: 1)
        collectionView.backgroundColor = teamColor(alpha: 0.04)
    }
    func updateLanguage() {
        switch userLang {
        case .English:
            title = "Opponent"
            battleButton.setTitle("Let's Battle!", forState: .Normal)
        case .Chinese, .Austrian:
            title = "對戰對手"
            battleButton.setTitle("確認，開始對戰！", forState: .Normal)
        }
    }
}

extension BattleOpponentViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonData.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        view.endEditing(true)
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? OpponentCollectionViewCell {
            OpponentImage.image = cell.imageView.image
            opponent = cell.pokemon
            calculateOpponentLevel()
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath)
        if let cell = cell as? OpponentCollectionViewCell {
            cell.pokemon = pokemonData[indexPath.row]
        }
        return cell
    }
}
