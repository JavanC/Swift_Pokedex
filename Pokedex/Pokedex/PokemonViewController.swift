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
    @IBOutlet weak var pokemonInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var trainerLevelLabel: UILabel!
    
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
    
    @IBOutlet weak var fastAttackSegmented: UISegmentedControl!
    @IBOutlet weak var chargeAttackSegmented: UISegmentedControl!
    @IBOutlet weak var fastAttackTypeLabel: UILabel!
    @IBOutlet weak var fastAttackPowerLabel: UILabel!
    @IBOutlet weak var fastAttackSecondLabel: UILabel!
    @IBOutlet weak var fastAttackDPSLabel: UILabel!
    @IBOutlet weak var fastAttackEnergyLabel: UILabel!
    @IBOutlet weak var chargeAttackTypeLabel: UILabel!
    @IBOutlet weak var chargeAttackPowerLabel: UILabel!
    @IBOutlet weak var chargeAttackSecondLabel: UILabel!
    @IBOutlet weak var chargeAttackDPSLabel: UILabel!
    @IBOutlet weak var chargeAttackEnergyLabel: UILabel!

    let levelRulerSlider = RulerSlider(frame: CGRectZero)
    let pokemonCPSlider = RangeSlider(frame: CGRectZero)
    let pokemonHPSlider = RangeSlider(frame: CGRectZero)
    let ivValueCircleLayer = CAShapeLayer()
    let cpValueArcLayer = CAShapeLayer()
    
    var pokemon: Pokemon!
    var trainerLevel = 0.0 {
        didSet {
            trainerLevel = min(max(trainerLevel, 1),40)
            trainerLevelLabel.text = "\(Int(trainerLevel))"
            
            let maxLevel = trainerLevel * 2 + 3 > 80 ? 80 : trainerLevel * 2 + 3
            levelRulerSlider.maximunValue = maxLevel
            let currentLevel = min(max(levelRulerSlider.currentValue, Double(levelRulerSlider.minimunValue)), Double(levelRulerSlider.maximunValue))
            levelRulerSlider.currentValue = currentLevel
            levelRulerSliderValueChanged(levelRulerSlider)
            
            NSUserDefaults.standardUserDefaults().setDouble(trainerLevel, forKey: "trainerLevel")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        updateViewForPokemon()
    }
    
    private func loadData() {
        let defaults = NSUserDefaults.standardUserDefaults()
        trainerLevel = defaults.doubleForKey("trainerLevel") != 0 ? defaults.doubleForKey("trainerLevel") : 20
    }
    
    private func updateViewForPokemon() {
        if let pokemon = pokemon {

            // for ipad autolayout
            if UIScreen.mainScreen().bounds.height > 826 + 64 {
                scrollView.scrollEnabled = false
                let constant = UIScreen.mainScreen().bounds.height - 64 - 596
                pokemonInfoViewHeightConstraint.constant = constant
                pokemonInfoView.layoutIfNeeded()
            }
            
            // update title name
            title = pokemon.name
            
            // background image and emitter
            pokemonInfoView.layer.zPosition = -1
            backgroundImage.image = UIImage(named: "\(pokemon.type[0])")
            let rect = CGRect(x: 0.0, y: backgroundImage.frame.height, width: view.bounds.width, height: 100)
            let emitter = EmitterLayer(rect: rect)
            backgroundImage.layer.addSublayer(emitter)
            
            // pokemonImage
            pokemonImage.image = UIImage(named: pokemon.number)
            
            // cp value arc
            drawCPValueArc()
            
            // iv value circle
            drawIVValueCircle()
            
            // ruler slider
            var rulerSliderMargin: CGFloat = UIScreen.mainScreen().bounds.width * 0.1
            if UIScreen.mainScreen().bounds.height > 826 + 64 {
                rulerSliderMargin = UIScreen.mainScreen().bounds.width / 2 - pokemonImage.frame.width * 1.2
            }
            let rulerSliderWidth = view.bounds.width - 2.0 * rulerSliderMargin
            let pokemonInfoViewHeight = pokemonInfoView.frame.height
    
            levelRulerSlider.frame = CGRect(x: rulerSliderMargin, y: pokemonInfoViewHeight - 25, width: rulerSliderWidth, height: 25.0)
            let maxLevel = trainerLevel * 2 + 3 > 80 ? 80 : trainerLevel * 2 + 3
            levelRulerSlider.maximunValue = maxLevel
            levelRulerSlider.currentValue = Double(Int((maxLevel + 4) / 2))
            levelRulerSliderValueChanged(levelRulerSlider)
            levelRulerSlider.addTarget(self, action: #selector(self.levelRulerSliderValueChanged), forControlEvents: .ValueChanged)
            scrollView.addSubview(levelRulerSlider)
            
            // range slider
            let rangeSliderMargin: CGFloat = UIScreen.mainScreen().bounds.width * 0.1
            let rangeSliderWidth = view.bounds.width - 2.0 * rangeSliderMargin
            pokemonCPSlider.frame = CGRect(x: rangeSliderMargin, y: 28, width: rangeSliderWidth, height: 25.0)
            let cpCurrentValue = Double(Int((pokemonCPSlider.minimunValue + pokemonCPSlider.maximunValue) / 2))
            pokemonCPSlider.currentValue = cpCurrentValue
            cpRangeSliderValueChanged(pokemonCPSlider)
            pokemonCPSlider.addTarget(self, action: #selector(self.cpRangeSliderValueChanged), forControlEvents: .ValueChanged)
            CPHPView.addSubview(pokemonCPSlider)
            
            pokemonHPSlider.frame = CGRect(x: rangeSliderMargin, y: 78, width: rangeSliderWidth, height: 25.0)
            let hpCurrentValue = Double(Int((pokemonHPSlider.minimunValue + pokemonHPSlider.maximunValue) / 2))
            pokemonHPSlider.currentValue = hpCurrentValue
            hpRangeSliderValueChanged(pokemonHPSlider)
            pokemonHPSlider.addTarget(self, action: #selector(self.hpRangeSliderValueChanged), forControlEvents: .ValueChanged)
            CPHPView.addSubview(pokemonHPSlider)
            
            // segmented
            fastAttackSegmented.layoutIfNeeded()
            fastAttackSegmented.removeAllSegments()
            for (index, fastAttack) in pokemon.fastAttacks.enumerate() {
                let attackName = fastAttack.name
                let segmementedWidth = fastAttackSegmented.frame.width
                let itemWidth = segmementedWidth / CGFloat(pokemon.fastAttacks.count)
                let textWidth = UILabel().textSize(attackName, font: UIFont.systemFontOfSize(13)).width
                if textWidth > itemWidth {
                    let text = attackName.stringByReplacingOccurrencesOfString(" ", withString: "\n")
                    let label = UILabel(frame: CGRectMake(0, 0, itemWidth, 29))
                    label.textAlignment = NSTextAlignment.Center
                    label.numberOfLines = 0
                    label.font = UIFont.systemFontOfSize(11)
                    label.text = text
                    fastAttackSegmented.insertSegmentWithImage(UIImage.imageWithLabel(label), atIndex: index, animated: false)
                } else {
                    fastAttackSegmented.insertSegmentWithTitle(attackName, atIndex: index, animated: false)
                }
            }
            fastAttackSegmented.selectedSegmentIndex = 0
            fastAttackSegmentValueChange(fastAttackSegmented)
            
            chargeAttackSegmented.layoutIfNeeded()
            chargeAttackSegmented.removeAllSegments()
            for (index, chargeAttack) in pokemon.chargeAttacks.enumerate() {
                let attackName = chargeAttack.name
                let segmementedWidth = chargeAttackSegmented.frame.width
                let itemWidth = segmementedWidth / CGFloat(pokemon.chargeAttacks.count) - 2
                let textWidth = UILabel().textSize(attackName, font: UIFont.systemFontOfSize(13)).width
                if textWidth > itemWidth {
                    let text = attackName.stringByReplacingOccurrencesOfString(" ", withString: "\n")
                    let label = UILabel(frame: CGRectMake(0, 0, itemWidth, 29))
                    label.textAlignment = NSTextAlignment.Center
                    label.numberOfLines = 0
                    label.font = UIFont.systemFontOfSize(11)
                    label.text = text
                    chargeAttackSegmented.insertSegmentWithImage(UIImage.imageWithLabel(label), atIndex: index, animated: false)
                } else {
                    chargeAttackSegmented.insertSegmentWithTitle(attackName, atIndex: index, animated: false)
                }
            }
            chargeAttackSegmented.selectedSegmentIndex = 0
            chargeAttackSegmentValueChange(chargeAttackSegmented)
        }
    }
    
    private func drawCPValueArc() {
        let arcCenter = CGPoint(x: view.bounds.width / 2, y: pokemonInfoView.bounds.height - 28)
        let StartAngel: CGFloat = CGFloat(M_PI)
        let EndAngel: CGFloat = 0
        let Radius: CGFloat = UIScreen.mainScreen().bounds.height > 796 + 64 ? pokemonImage.frame.width * 1.2 : view.bounds.width * 0.4
        let path = UIBezierPath(arcCenter: arcCenter, radius: Radius, startAngle: StartAngel, endAngle: EndAngel, clockwise: true)
    
        let cpArcBackgroundLayer = CAShapeLayer()
        cpArcBackgroundLayer.path = path.CGPath
        cpArcBackgroundLayer.lineWidth = 2
        cpArcBackgroundLayer.fillColor = UIColor.clearColor().CGColor
        cpArcBackgroundLayer.strokeColor = UIColor(hex: 0xFFFFFF, alpha: 0.5).CGColor
        pokemonInfoView.layer.addSublayer(cpArcBackgroundLayer)
        
        cpValueArcLayer.path = path.CGPath
        cpValueArcLayer.lineWidth = 2
        cpValueArcLayer.fillColor = UIColor.clearColor().CGColor
        cpValueArcLayer.strokeColor = UIColor.whiteColor().CGColor
        pokemonInfoView.layer.addSublayer(cpValueArcLayer)
    }
    
    private func drawIVValueCircle() {
        let arcCenter = CGPoint(x: view.bounds.width / 2, y: ivValueView.bounds.height / 2)
        let startAngle: CGFloat = CGFloat(-M_PI_2)
        let endAngle: CGFloat = CGFloat(M_PI_2 * 3)
        let path = UIBezierPath(arcCenter: arcCenter, radius: 29, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        ivValueCircleLayer.path = path.CGPath
        ivValueCircleLayer.lineWidth = 16
        ivValueCircleLayer.fillColor = UIColor.clearColor().CGColor
        ivValueCircleLayer.strokeColor = color4.CGColor
        ivValueCircleLayer.opacity = 0.2
        ivValueCircleLayer.zPosition = -1
        ivValueCircleLayer.strokeEnd = 0.0
        ivValueView.layer.addSublayer(ivValueCircleLayer)
    }
    
    @IBAction func trainerLevelMinus(sender: AnyObject) { trainerLevel -= 1 }
    @IBAction func trainerLevelPlus(sender: AnyObject) { trainerLevel += 1 }
    
    func levelRulerSliderValueChanged(rulerSlider: RulerSlider) {
        pokemon.level = rulerSlider.currentValue / 2
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
        
        let maxCPM = levelData[rulerSlider.maximunValue / 2]!["CPM"]!
        cpValueArcLayer.strokeEnd = CGFloat((pokemon.CPM - 0.094) / (maxCPM - 0.094))
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
    
    @IBAction func fastAttackSegmentValueChange(sender: AnyObject) {
        let attack = pokemon.fastAttacks[sender.selectedSegmentIndex]
        let power = pokemon.type.contains(attack.type) ? attack.damage * 1.25 : attack.damage
        let second = attack.duration
        let DPS = power / attack.duration
        let energy = attack.energy
        fastAttackTypeLabel.text = "\(attack.type)"
        fastAttackPowerLabel.text = power % 1 == 0 ? "\(Int(power))" : String(format: "%.1f", power)
        fastAttackSecondLabel.text = second % 1 == 0 ? "\(Int(second))" : "\(second)"
        fastAttackDPSLabel.text = DPS % 1 == 0 ? "\(Int(DPS))" : String(format: "%.1f", DPS)
        fastAttackEnergyLabel.text = energy % 1 == 0 ? "\(Int(energy))" : "\(energy)"
    }
    
    @IBAction func chargeAttackSegmentValueChange(sender: AnyObject) {
        let attack = pokemon.chargeAttacks[sender.selectedSegmentIndex]
        let power = pokemon.type.contains(attack.type) ? attack.damage * 1.25 : attack.damage
        let second = attack.duration
        let DPS = power / attack.duration
        let energy = attack.energy
        chargeAttackTypeLabel.text = "\(attack.type)"
        chargeAttackPowerLabel.text = power % 1 == 0 ? "\(Int(power))" : String(format: "%.1f", power)
        chargeAttackSecondLabel.text = second % 1 == 0 ? "\(Int(second))" : "\(second)"
        chargeAttackDPSLabel.text = DPS % 1 == 0 ? "\(Int(DPS))" : String(format: "%.1f", DPS)
        chargeAttackEnergyLabel.text = energy % 1 == 0 ? "\(Int(energy))" : "\(energy)"
    }
}