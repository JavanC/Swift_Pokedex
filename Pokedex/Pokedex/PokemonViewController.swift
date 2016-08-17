//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Javan.Chen on 2016/8/17.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewForPokemon()
        
        print(UIScreen.mainScreen().bounds.size.height)
        let rect = CGRect(x: 0.0, y: 180, width: view.bounds.width, height: 20.0)
        let emitter = EmitterLayer(rect: rect)
        imageView.layer.addSublayer(emitter)
    }
    
    private func updateViewForPokemon() {
        if let pokemon = pokemon {
            pokemonName?.text = pokemon.number
            title = pokemon.name
        }
    }
}