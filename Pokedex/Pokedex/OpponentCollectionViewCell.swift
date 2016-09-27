//
//  OpponentCollectionViewCell.swift
//  Poke Booklet
//
//  Created by Javan on 2016/9/27.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

class OpponentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    var pokemon:Pokemon? {
        didSet {
            imageView.image = UIImage(named: pokemon!.number)
        }
    }
    
    override var selected: Bool {
        get {
            return super.selected
        }
        set {
            if newValue {
                super.selected = true
                self.backgroundColor = teamColor(alpha: 0.5)
                self.layer.cornerRadius = 20
            } else if newValue == false {
                super.selected = false
                self.backgroundColor = UIColor.clearColor()
            }
        }
    }
}
