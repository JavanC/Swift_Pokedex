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
    
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var estimatedLevelLabel: UILabel!
    @IBOutlet weak var stardustLabel: UILabel!
    @IBOutlet weak var candyLabel: UILabel!
    
    @IBOutlet weak var cpValueLabel: UILabel!
    @IBOutlet weak var hpValueLabel: UILabel!
    @IBOutlet weak var cpRangeValueLabel2: UILabel!
    @IBOutlet weak var hpRangeValueLabel2: UILabel!
    
    let pokemonCPSlider = RangeSlider(frame: CGRectZero)
    let pokemonHPSlider = RangeSlider(frame: CGRectZero)
    
    @IBOutlet weak var ivStaLabel: UILabel!
    var pokemon: Pokemon!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewForPokemon()
        
        // background image emitter
        let rect = CGRect(x: 0.0, y: 240, width: view.bounds.width, height: 130.0)
        let emitter = EmitterLayer(rect: rect)
        backgroundImage.layer.addSublayer(emitter)
        
        // pokemonImage
        pokemonImage.image = UIImage(named: pokemon.number)
        
        // slider
        levelRangeSliderValueChanged(levelRangeSlider)
        levelRangeSlider.addTarget(self, action: #selector(self.levelRangeSliderValueChanged), forControlEvents: .ValueChanged)
        scrollView.addSubview(levelRangeSlider)

        // CP Slider
        scrollView.addSubview(pokemonCPSlider)
        
        // hp slider
        hpRangeSliderValueChanged(pokemonHPSlider)
        pokemonHPSlider.addTarget(self, action: #selector(self.hpRangeSliderValueChanged), forControlEvents: .ValueChanged)
//        pokemonHPSlider.minimunValue = 50
//        pokemonHPSlider.maximunValue = 100
//        pokemonHPSlider.currentValue = 75
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
        
        pokemon.level = rangeSlider.currentValue / 2
        estimatedLevelLabel.text = pokemon.level % 1 == 0 ? "\(Int(pokemon.level))" : "\(pokemon.level)"
        
        let CPM = CPMs[pokemon.level]!
        let minHp = Int(pokemon.baseSta * CPM > 10 ? pokemon.baseSta * CPM : 10)
        let maxHp = Int((pokemon.baseSta + 15) * CPM > 10 ? (pokemon.baseSta + 15) * CPM : 10)
        hpRangeValueLabel.text = "\(minHp)-\(maxHp)"
        hpRangeValueLabel2.text = "\(minHp) - \(maxHp)"
        pokemonHPSlider.minimunValue = Double(minHp)
        pokemonHPSlider.maximunValue = Double(maxHp)
        pokemonHPSlider.currentValue = min(max(pokemonHPSlider.currentValue, Double(minHp)), Double(maxHp))
        hpValueLabel.text = "\(Int(pokemonHPSlider.currentValue))"
        
        cpRangeValueLabel.text = "\(Int(rangeSlider.currentValue * 80))-\(Int(rangeSlider.currentValue * 100))"
        
    }
    
    func hpRangeSliderValueChanged(rangeSlider: RangeSlider) {
        hpValueLabel.text = "\(Int(rangeSlider.currentValue))"
    }
    
    func calculateIV(level: Double, cp: Double, hp: Double) {
//        let baseAtt = pokemon.baseAtt
//        let baseDef = pokemon.baseDef
//        let baseSta = pokemon.baseSta
//        let CPM = CPMs[level]!
//        pokemon.indiSta = hp / CPM - baseSta
    }
}