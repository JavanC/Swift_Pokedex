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
    
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var estimatedLevelLabel: UILabel!
    @IBOutlet weak var stardustLabel: UILabel!
    @IBOutlet weak var candyLabel: UILabel!
    
    @IBOutlet weak var CPHPView: MyCustomView!
    @IBOutlet weak var cpValueLabel: UILabel!
    @IBOutlet weak var hpValueLabel: UILabel!
    @IBOutlet weak var cpRangeValueLabel2: UILabel!
    @IBOutlet weak var hpRangeValueLabel2: UILabel!
    
    @IBOutlet weak var attDefValueLabel: UILabel!
    @IBOutlet weak var staValueLabel: UILabel!
    @IBOutlet weak var ivValueLabel: UILabel!
    @IBOutlet weak var ivValueView: MyCustomView!
    
    @IBOutlet weak var estimatedViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var powerUpViewTopConstraint: NSLayoutConstraint!
    
    let levelRangeSlider = RangeSlider(frame: CGRectZero)
    let pokemonCPSlider = RangeSlider(frame: CGRectZero)
    let pokemonHPSlider = RangeSlider(frame: CGRectZero)
    let ivValueCircleLayer = CAShapeLayer()
    
    @IBOutlet weak var ivStaLabel: UILabel!
    var pokemon: Pokemon!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewForPokemon()
    }
    
    private func updateViewForPokemon() {
        if let pokemon = pokemon {
            
            // for ipad autolayout
            if UIScreen.mainScreen().bounds.height > 796 + 64 {
                scrollView.scrollEnabled = false
                let constant = UIScreen.mainScreen().bounds.height - 64 - 596
                estimatedViewTopConstraint.constant = constant
                powerUpViewTopConstraint.constant = constant
            }
            
            // update title name
            title = pokemon.name
            
            // background image emitter
            let halfHeight = view.bounds.height / 2
            let rect = CGRect(x: 0.0, y: halfHeight, width: view.bounds.width, height: halfHeight)
            let emitter = EmitterLayer(rect: rect)
            backgroundImage.layer.addSublayer(emitter)
            
            // pokemonImage
            pokemonImage.image = UIImage(named: pokemon.number)
            
            // slider
            let margin: CGFloat = UIScreen.mainScreen().bounds.width * 0.1
            let width = view.bounds.width - 2.0 * margin
            
            levelRangeSlider.frame = CGRect(x: margin, y: 180, width: width, height: 25.0)
            levelRangeSliderValueChanged(levelRangeSlider)
            levelRangeSlider.addTarget(self, action: #selector(self.levelRangeSliderValueChanged), forControlEvents: .ValueChanged)
            scrollView.addSubview(levelRangeSlider)
            
            pokemonCPSlider.frame = CGRect(x: margin, y: 28, width: width, height: 25.0)
            pokemonCPSlider.addTarget(self, action: #selector(self.cpRangeSliderValueChanged), forControlEvents: .ValueChanged)
            CPHPView.addSubview(pokemonCPSlider)
            
            pokemonHPSlider.frame = CGRect(x: margin, y: 78, width: width, height: 25.0)
            pokemonHPSlider.addTarget(self, action: #selector(self.hpRangeSliderValueChanged), forControlEvents: .ValueChanged)
            CPHPView.addSubview(pokemonHPSlider)
            
            // iv value circle
            let arcCenter = CGPoint(x: view.bounds.width / 2, y: ivValueView.bounds.height / 2)
            let startAngle: CGFloat = CGFloat(-M_PI_2)
            let endAngle: CGFloat = CGFloat(M_PI_2 * 3)
            let path = UIBezierPath(arcCenter: arcCenter, radius: 29, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            ivValueCircleLayer.path = path.CGPath
            ivValueCircleLayer.lineWidth = 16
            ivValueCircleLayer.fillColor = UIColor.clearColor().CGColor
            ivValueCircleLayer.strokeColor = UIColor.init(colorLiteralRed: 0.966, green: 0.74, blue: 0.222, alpha: 1.0).CGColor
            ivValueCircleLayer.opacity = 0.2
            ivValueCircleLayer.zPosition = -1
            ivValueCircleLayer.strokeEnd = 0.0
            ivValueView.layer.addSublayer(ivValueCircleLayer)
        }
    }
    
    func levelRangeSliderValueChanged(rangeSlider: RangeSlider) {
        pokemon.level = rangeSlider.currentValue / 2
        estimatedLevelLabel.text = pokemon.level % 1 == 0 ? "\(Int(pokemon.level))" : "\(pokemon.level)"
        stardustLabel.text = "\(Int(pokemon.stardust))"
        candyLabel.text = "\(Int(pokemon.candy))"
        
        hpRangeValueLabel.text = "\(Int(pokemon.minHp))-\(Int(pokemon.maxHp))"
        hpRangeValueLabel2.text = "\(Int(pokemon.minHp)) - \(Int(pokemon.maxHp))"
        pokemonHPSlider.minimunValue = pokemon.minHp
        pokemonHPSlider.maximunValue = pokemon.maxHp
        pokemonHPSlider.currentValue = pokemon.hp
        hpRangeSliderValueChanged(pokemonHPSlider)
        
        cpRangeValueLabel.text = "\(Int(pokemon.minCp))-\(Int(pokemon.maxCp))"
        cpRangeValueLabel2.text = "\(Int(pokemon.minCp)) - \(Int(pokemon.maxCp))"
        pokemonCPSlider.minimunValue = pokemon.minCp
        pokemonCPSlider.maximunValue = pokemon.maxCp
        pokemonCPSlider.currentValue = pokemon.cp
        cpRangeSliderValueChanged(pokemonCPSlider)
    }
    
    func cpRangeSliderValueChanged(rangeSlider: RangeSlider) {
        pokemon.cp = rangeSlider.currentValue
        cpValueLabel.text = "\(Int(pokemon.cp))"
        updateIVView()
    }
    
    func hpRangeSliderValueChanged(rangeSlider: RangeSlider) {
        pokemon.hp = rangeSlider.currentValue
        hpValueLabel.text = "\(Int(pokemon.hp))"
        updateIVView()
    }
    
    func updateIVView() {
        let attDef = pokemon.indiAtt + pokemon.indiDef
        let sta = pokemon.indiSta
        let persent = (attDef + sta) / 45
        attDefValueLabel.text = "\(Int(attDef)) / 30"
        staValueLabel.text = "\(Int(sta)) / 15"
        ivValueLabel.text = "\(Int(persent * 100))%"
        ivValueCircleLayer.strokeEnd = CGFloat(persent)
    }
}