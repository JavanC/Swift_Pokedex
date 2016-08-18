//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Javan.Chen on 2016/8/17.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var cpRangeValueLabel: UILabel!
    @IBOutlet weak var hpRangeValueLabel: UILabel!
    let levelRangeSlider = RangeSlider(frame: CGRectZero)
    
    @IBOutlet weak var estimatedLevelLabel: UILabel!
    @IBOutlet weak var stardustLabel: UILabel!
    @IBOutlet weak var candyLabel: UILabel!
    
    let pokemonCPSlider = RangeSlider(frame: CGRectZero)
    let pokemonHPSlider = RangeSlider(frame: CGRectZero)
    
    var pokemon: Pokemon!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewForPokemon()
        
        // background image emitter
        let rect = CGRect(x: 0.0, y: 240, width: view.bounds.width, height: 130.0)
        let emitter = EmitterLayer(rect: rect)
        backgroundImage.layer.addSublayer(emitter)
        
        // slider
        levelRangeSliderValueChanged(levelRangeSlider)
        levelRangeSlider.addTarget(self, action: #selector(self.levelRangeSliderValueChanged), forControlEvents: .ValueChanged)
        scrollView.addSubview(levelRangeSlider)

        scrollView.addSubview(pokemonCPSlider)
        scrollView.addSubview(pokemonHPSlider)
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 30.0
        let width = view.bounds.width - 2.0 * margin
        levelRangeSlider.frame = CGRect(x: margin, y: 180, width: width, height: 20.0)
        pokemonCPSlider.frame = CGRect(x: margin, y: 288, width: width, height: 20.0)
        pokemonHPSlider.frame = CGRect(x: margin, y: 333, width: width, height: 20.0)
    }
    
    private func updateViewForPokemon() {
        if let pokemon = pokemon {
            title = pokemon.name
        }
    }
    
    func levelRangeSliderValueChanged(rangeSlider: RangeSlider) {
        cpRangeValueLabel.text = "\(Int(rangeSlider.currentValue * 80))-\(Int(rangeSlider.currentValue * 100))"
        hpRangeValueLabel.text = "\(Int(rangeSlider.currentValue * 8))-\(Int(rangeSlider.currentValue * 10))"
        estimatedLevelLabel.text = "\(Int(rangeSlider.currentValue) / 2)"
    }
}