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
    @IBOutlet weak var sliderArea: UIView!
    
    let rangeSlider = RangeSlider(frame: CGRectZero)
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewForPokemon()
        
        // imageview background emitter
        let rect = CGRect(x: 0.0, y: 180, width: view.bounds.width, height: 20.0)
        let emitter = EmitterLayer(rect: rect)
        imageView.layer.addSublayer(emitter)
        
        // slider
        rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueChanged), forControlEvents: .ValueChanged)
        ScrollView.addSubview(rangeSlider)
    
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
//        rangeSlider.backgroundColor = UIColor.redColor()
        rangeSlider.frame = CGRect(x: margin, y: margin + topLayoutGuide.length, width: width, height: 31.0)
    }
    
    
    private func updateViewForPokemon() {
        if let pokemon = pokemon {
            pokemonName?.text = pokemon.number
            title = pokemon.name
        }
    }
    
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        print("value change: (\(rangeSlider.currentValue))")
    }
}