//
//  ProIVViewController.swift
//  Poke Booklet
//
//  Created by Javan.Chen on 2016/9/5.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

protocol pokemonDelegate{
    func sendPokemonData(pokemon: Pokemon)
}

class ProIVViewController: UIViewController {
    var pokemon: Pokemon!
    var delegate : pokemonDelegate?
    @IBOutlet weak var cpValueLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        cpValueLabel.text = "\(pokemon.cp)"
        pokemon.cp += 1
        pokemon.cp += 1
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        delegate?.sendPokemonData(pokemon)
    }
    
    override func viewWillAppear(animated: Bool) {
        updateLanguage()
    }
    
    func updateLanguage() {
        
    }
}