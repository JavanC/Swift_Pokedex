//
//  PokedexCollectionViewCell.swift
//  Pokedex
//
//  Created by Javan on 2016/8/17.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

class PokedexCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pokeNumber: UILabel!
    
    var pokemon:Pokemon? {
        didSet {
            
            imageView.image = UIImage(named: pokemon!.number)
            pokeNumber.text = pokemon?.number
        }
    }
}
