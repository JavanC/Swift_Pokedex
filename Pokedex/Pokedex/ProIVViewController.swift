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
    @IBOutlet weak var stardustLabel: UILabel!
    @IBOutlet weak var cpValueLabel: UILabel!
    @IBOutlet weak var hpValueLabel: UILabel!
    
    @IBOutlet weak var analysisView: UIView!
    @IBOutlet weak var analysisLabel: UILabel!
    @IBOutlet weak var bestStatsView: UIView!
    @IBOutlet weak var bestStatsLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var ATKLabel: UILabel!
    @IBOutlet weak var DEFLabel: UILabel!
    @IBOutlet weak var STALabel: UILabel!
    
    @IBOutlet weak var ATKButton: MyCustomButton!
    @IBOutlet weak var DEFButton: MyCustomButton!
    @IBOutlet weak var STAButton: MyCustomButton!
    @IBOutlet weak var OKButton: UIButton!
    
    var pokemon: Pokemon!
    var delegate : pokemonDelegate?
    let analysisSlider = RangeSlider(frame: CGRectZero)
    let statsSlider = RangeSlider(frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    override func viewWillAppear(animated: Bool) {
        updateTeamColor()
        updateLanguage()
    }
    
    private func configureView() {
        stardustLabel.text = "\(Int(pokemon.stardust))"
        cpValueLabel.text = "\(Int(pokemon.cp))"
        hpValueLabel.text = "\(Int(pokemon.hp))"
        
        // range slider
        let rangeSliderHeight: CGFloat = 25
        let rangeSliderMargin: CGFloat = UIScreen.mainScreen().bounds.width * 0.1 - rangeSliderHeight / 2
        let rangeSliderWidth = view.bounds.width - 2.0 * rangeSliderMargin
        analysisSlider.frame = CGRect(x: rangeSliderMargin, y: 65, width: rangeSliderWidth, height: rangeSliderHeight)
        analysisSlider.showPoint = true
        analysisSlider.minimunValue = 1
        analysisSlider.maximunValue = 4
        analysisSlider.currentValue = 1
        analysisSliderValueChanged(analysisSlider)
        analysisSlider.addTarget(self, action: #selector(self.analysisSliderValueChanged), forControlEvents: .ValueChanged)
        analysisView.addSubview(analysisSlider)
        
        statsSlider.frame = CGRect(x: rangeSliderMargin, y: 115, width: rangeSliderWidth, height: rangeSliderHeight)
        statsSlider.showPoint = true
        statsSlider.minimunValue = 1
        statsSlider.maximunValue = 4
        statsSlider.currentValue = 1
        statsSliderValueChange(statsSlider)
        statsSlider.addTarget(self, action: #selector(self.statsSliderValueChange), forControlEvents: .ValueChanged)
        bestStatsView.addSubview(statsSlider)        
    }
    func analysisSliderValueChanged(rangeSlider: RangeSlider) {
        calculateIndiValue()
    }
    func statsSliderValueChange(rangeSlider: RangeSlider) {
        calculateIndiValue()
    }
    @IBAction func touchUpATKButton(sender: AnyObject) {
        ATKButton.isSelect = !ATKButton.isSelect
        calculateIndiValue()
    }
    @IBAction func touchUpDEFButton(sender: AnyObject) {
        DEFButton.isSelect = !DEFButton.isSelect
        calculateIndiValue()
    }
    @IBAction func touchUpSTAButton(sender: AnyObject) {
        STAButton.isSelect = !STAButton.isSelect
        calculateIndiValue()
    }
    func calculateIndiValue() {
        if ATKButton.isSelect || DEFButton.isSelect || STAButton.isSelect {
            let cp = pokemon.cp
            let hp = pokemon.hp
            print("now cp: \(cp), hp: \(hp)")
            let levels = stardustLevel[pokemon.stardust]!
            
            // analysis filter
            var possibleData = [[Double]]()
            for level in levels {
                // remove out of cp and hp range
                pokemon.level = level
                if cp > pokemon.maxCp || cp < pokemon.minCp || hp > pokemon.maxHp || hp < pokemon.minHp { continue }
                print("level: \(level)")
                
                pokemon.cp = cp
                pokemon.hp = hp
                for levelPossibleData in pokemon.possibleIndiValue() {
                    print(levelPossibleData)
                    let totalStats = levelPossibleData[1] + levelPossibleData[2] + levelPossibleData[3]
                    switch analysisSlider.currentValue {
                    case 1:
                        if totalStats >= 37{
                            possibleData.append(levelPossibleData)
                        }
                    case 2:
                        if totalStats >= 30 && totalStats <= 36{
                            possibleData.append(levelPossibleData)
                        }
                    case 3:
                        if totalStats >= 23 && totalStats <= 29{
                            possibleData.append(levelPossibleData)
                        }
                    case 4:
                        if totalStats <= 28{
                            possibleData.append(levelPossibleData)
                        }
                    default:
                        print("error")
                    }
                }
            }
            print("analysis filter data")
            print(possibleData)
            
            // best stats filter
            for (index, data) in possibleData.enumerate().reverse() {
                let maxValue = max(data[1], data[2], data[3])
                switch statsSlider.currentValue {
                case 1:
                    if maxValue != 15 {
                        possibleData.removeAtIndex(index)
                        continue
                    }
                case 2:
                    if maxValue < 13 || maxValue > 14 {
                        possibleData.removeAtIndex(index)
                        continue
                    }
                case 3:
                    if maxValue < 8 || maxValue > 12 {
                        possibleData.removeAtIndex(index)
                        continue
                    }
                case 4:
                    if maxValue > 7 {
                        possibleData.removeAtIndex(index)
                        continue
                    }
                default:
                    print("error")
                }
                
                if ATKButton.isSelect && maxValue != data[1] {
                    possibleData.removeAtIndex(index)
                    continue
                }
                if !ATKButton.isSelect && maxValue == data[1] {
                    possibleData.removeAtIndex(index)
                    continue
                }
                if DEFButton.isSelect && maxValue != data[2] {
                    possibleData.removeAtIndex(index)
                    continue
                }
                if !DEFButton.isSelect && maxValue == data[2] {
                    possibleData.removeAtIndex(index)
                    continue
                }
                if STAButton.isSelect && maxValue != data[3] {
                    possibleData.removeAtIndex(index)
                    continue
                }
                if !STAButton.isSelect && maxValue == data[3] {
                    possibleData.removeAtIndex(index)
                    continue
                }
            }
            print("best stats filter data")
            print(possibleData)
            if possibleData.count != 0 {
                levelLabel.text = "\(Int(possibleData[0][0]))"
                ATKLabel.text = "\(Int(possibleData[0][1]))"
                DEFLabel.text = "\(Int(possibleData[0][2]))"
                STALabel.text = "\(Int(possibleData[0][3]))"
            } else {
                levelLabel.text = "?"
                ATKLabel.text = "?"
                DEFLabel.text = "?"
                STALabel.text = "?"
            }
        } else {
            levelLabel.text = "?"
            ATKLabel.text = "?"
            DEFLabel.text = "?"
            STALabel.text = "?"
        }
    }
    
    // update team and language
    func updateTeamColor() {
        switch userTeam {
        case .Instinct:
            analysisSlider.trackTintColor = colorY
            statsSlider.trackTintColor = colorY
            ATKButton.buttonColor = colorY
            DEFButton.buttonColor = colorY
            STAButton.buttonColor = colorY
        case .Mystic:
            analysisSlider.trackTintColor = colorB
            statsSlider.trackTintColor = colorB
            ATKButton.buttonColor = colorB
            DEFButton.buttonColor = colorB
            STAButton.buttonColor = colorB
        case .Valor:
            analysisSlider.trackTintColor = colorR
            statsSlider.trackTintColor = colorR
            ATKButton.buttonColor = colorR
            DEFButton.buttonColor = colorR
            STAButton.buttonColor = colorR
        }
    }
    func updateLanguage() {
        
    }
}