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
    @IBOutlet weak var pokemonInfoView: UIView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var cpRangeValueLabel: UILabel!
    @IBOutlet weak var hpRangeValueLabel: UILabel!
    let rangeSlider = RangeSlider(frame: CGRectZero)
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewForPokemon()
        
        // background image emitter
        let rect = CGRect(x: 0.0, y: 180, width: view.bounds.width, height: 20.0)
        let emitter = EmitterLayer(rect: rect)
        backgroundImage.layer.addSublayer(emitter)
        
        // pokemon info view
        pokemonInfoView.backgroundColor = UIColor.clearColor()
        
        // slider
        rangeSliderValueChanged(rangeSlider)
        rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueChanged), forControlEvents: .ValueChanged)
        scrollView.addSubview(rangeSlider)

    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 40.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider.frame = CGRect(x: margin, y: 200, width: width, height: 25.0)
    }
    
    
    private func updateViewForPokemon() {
        if let pokemon = pokemon {
            pokemonNameLabel?.text = pokemon.name
            title = pokemon.name
        }
    }
    
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        cpRangeValueLabel.text = "\(Int(rangeSlider.currentValue * 80))-\(Int(rangeSlider.currentValue * 100))"
        hpRangeValueLabel.text = "\(Int(rangeSlider.currentValue * 8))-\(Int(rangeSlider.currentValue * 10))"
    }
}