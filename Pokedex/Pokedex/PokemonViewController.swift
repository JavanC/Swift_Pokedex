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
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewForPokemon()
        
        // imageview background emitter
        let rect = CGRect(x: 0.0, y: 180, width: view.bounds.width, height: 20.0)
        let emitter = EmitterLayer(rect: rect)
        imageView.layer.addSublayer(emitter)
        
        // slider
        self.buildCircleSlider()
    }
    
    private func updateViewForPokemon() {
        if let pokemon = pokemon {
            pokemonName?.text = pokemon.number
            title = pokemon.name
        }
    }
    
    private var valueLabel: UILabel!
    private func buildCircleSlider() {
        var circleSlider: CircleSlider!
        let sliderOptions: [CircleSliderOption] = [
                .BarColor(UIColor(red: 198/255, green: 244/255, blue: 23/255, alpha: 0.2)),
                .ThumbColor(UIColor(red: 141/255, green: 185/255, blue: 204/255, alpha: 1)),
                .TrackingColor(UIColor(red: 78/255, green: 136/255, blue: 185/255, alpha: 1)),
                .BarWidth(20),
                .StartAngle(-45),
                .MaxValue(150),
                .MinValue(20)
            ]
        circleSlider = CircleSlider(frame: self.sliderArea.bounds, options: sliderOptions)
        circleSlider?.addTarget(self, action: #selector(self.valueChange(_:)), forControlEvents: .ValueChanged)
        sliderArea.addSubview(circleSlider!)
        valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        valueLabel.textAlignment = .Center
        valueLabel.center = CGPoint(x: CGRectGetWidth(circleSlider.bounds) * 0.5, y: CGRectGetHeight(circleSlider.bounds) * 1.2)
        circleSlider.addSubview(self.valueLabel)
    }
    func valueChange(sender: CircleSlider) {
        self.valueLabel.text = "\(Int(sender.value))"
    }
}