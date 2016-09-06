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
    
    var cp: Double!
    var hp: Double!
    var starDust: Double!
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
        // Initial navigation bar
        title = "IV Calculator Pro"
        self.navigationController?.navigationBar.translucent = false
        let navigationBarFrame = self.navigationController!.navigationBar.frame
        let shadowView = UIView(frame: navigationBarFrame)
        shadowView.backgroundColor = UIColor.whiteColor()
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius =  4
        shadowView.layer.position = CGPoint(x: navigationBarFrame.width / 2, y:  -navigationBarFrame.height / 2)
        self.view.addSubview(shadowView)
        
        // load data
        cp = pokemon.cp
        hp = pokemon.hp
        starDust = pokemon.stardust
        
        stardustLabel.text = "\(Int(starDust))"
        cpValueLabel.text = "\(Int(cp))"
        hpValueLabel.text = "\(Int(hp))"
        
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
        switch userTeam {
        case .Instinct:
            switch rangeSlider.currentValue {
            case 1: analysisLabel.text = "Overall, your \(pokemon.name[0]) looks like it can really battle with the best of them!"
            case 2: analysisLabel.text = "Overall, your \(pokemon.name[0]) is really strong!"
            case 3: analysisLabel.text = "Overall, your \(pokemon.name[0]) is pretty decent!"
            case 4: analysisLabel.text = "Overall, your \(pokemon.name[0]) has room for improvement as far as battling goes."
            default: print("error")
            }
        case .Mystic:
            switch rangeSlider.currentValue {
            case 1: analysisLabel.text = "Overall, your \(pokemon.name[0]) is a wonder! What a breathtaking Pokemon!"
            case 2: analysisLabel.text = "Overall, your \(pokemon.name[0]) has certainly caught my attention."
            case 3: analysisLabel.text = "Overall, your \(pokemon.name[0]) is above average."
            case 4: analysisLabel.text = "Overall, your \(pokemon.name[0]) is not likely to make much headway in battle"
            default: print("error")
            }
        case .Valor:
            switch rangeSlider.currentValue {
            case 1: analysisLabel.text = "Overall, your \(pokemon.name[0]) simply amazes me. It can accomplish anything!"
            case 2: analysisLabel.text = "Overall, your \(pokemon.name[0]) is a strong Pokemon. You should be proud!"
            case 3: analysisLabel.text = "Overall, your \(pokemon.name[0]) is a decent Pokemon"
            case 4: analysisLabel.text = "Overall, your \(pokemon.name[0]) may not be great in battle, but I still like it!"
            default: print("error")
            }
        }
        calculateIndiValue()
    }
    func statsSliderValueChange(rangeSlider: RangeSlider) {
        switch userTeam {
        case .Instinct:
            switch rangeSlider.currentValue {
            case 1: bestStatsLabel.text = "Its stats are the best I've ever seen! No doubt about it!"
            case 2: bestStatsLabel.text = "Its stats are really strong! Impressive."
            case 3: bestStatsLabel.text = "It's definitely got some good stats. Definitely!"
            case 4: bestStatsLabel.text = "Its stats are all right, but kinda basic, as far as I can see."
            default: print("error")
            }
        case .Mystic:
            switch rangeSlider.currentValue {
            case 1: bestStatsLabel.text = "Its stats exceed my calculations. It's incredible!"
            case 2: bestStatsLabel.text = "I am certainly impressed by its stats, I must say."
            case 3: bestStatsLabel.text = "Its stats are noticeably trending to the positive."
            case 4: bestStatsLabel.text = "Its stats are not out of the norm, in my estimation."
            default: print("error")
            }
        case .Valor:
            switch rangeSlider.currentValue {
            case 1: bestStatsLabel.text = "I'm blown away by its stats. WOW!"
            case 2: bestStatsLabel.text = "It's got excellent stats! How exciting!"
            case 3: bestStatsLabel.text = "Its stats indicate that in battle, it'll get the job done."
            case 4: bestStatsLabel.text = "Its stats don't point to greatness in battle."
            default: print("error")
            }
        }
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
                var maxValue: Double = 0
                var maxAtk: Double = 0
                var maxDef: Double = 0
                for data in possibleData {
                    if data[1] + data[2] + data[3] > maxValue && data[1] >= maxAtk && data[2] >= maxDef {
                        maxValue = data[1] + data[2] + data[3]
                        maxAtk = data[1]
                        maxDef = data[2]
                        levelLabel.text = "\(Int(data[0]))"
                        ATKLabel.text = "\(Int(data[1]))"
                        DEFLabel.text = "\(Int(data[2]))"
                        STALabel.text = "\(Int(data[3]))"
                        pokemon.level = data[0]
                        pokemon.cp = cp
                        pokemon.hp = hp
                        pokemon.indiAtk = data[1]
                        pokemon.indiDef = data[2]
                        pokemon.indiSta = data[3]
                    }
                }
                OKButton.enabled = true
                if userTeam == .Instinct {
                    OKButton.backgroundColor = colorY
                } else if userTeam == .Mystic {
                    OKButton.backgroundColor = colorB
                } else {
                    OKButton.backgroundColor = colorR
                }
            } else {
                levelLabel.text = "?"
                ATKLabel.text = "?"
                DEFLabel.text = "?"
                STALabel.text = "?"
                OKButton.enabled = false
                OKButton.backgroundColor = UIColor.lightGrayColor()
            }
        } else {
            levelLabel.text = "?"
            ATKLabel.text = "?"
            DEFLabel.text = "?"
            STALabel.text = "?"
            OKButton.enabled = false
            OKButton.backgroundColor = UIColor.lightGrayColor()
        }
    }
    @IBAction func touchUpOKButton(sender: AnyObject) {
        delegate?.sendPokemonData(pokemon)
        self.navigationController?.popViewControllerAnimated(true)
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