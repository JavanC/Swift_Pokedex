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
    
    @IBOutlet weak var analysisView: MyCustomView!
    @IBOutlet weak var bestStatsView: MyCustomView!
    @IBOutlet weak var ATKButton: MyCustomButton!
    @IBOutlet weak var DEFButton: MyCustomButton!
    @IBOutlet weak var STAButton: MyCustomButton!
    
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
    override func didMoveToParentViewController(parent: UIViewController?) {
        delegate?.sendPokemonData(pokemon)
    }
    
    private func configureView() {
        stardustLabel.text = "\(Int(pokemon.stardust))"
        cpValueLabel.text = "\(Int(pokemon.cp))"
        hpValueLabel.text = "\(Int(pokemon.hp))"
        
        // range slider
        let rangeSliderHeight: CGFloat = 25
        let rangeSliderMargin: CGFloat = UIScreen.mainScreen().bounds.width * 0.1 - rangeSliderHeight / 2
        let rangeSliderWidth = view.bounds.width - 2.0 * rangeSliderMargin
        analysisSlider.frame = CGRect(x: rangeSliderMargin, y: 27, width: rangeSliderWidth, height: rangeSliderHeight)
        analysisSlider.showPoint = true
        analysisSlider.minimunValue = 1
        analysisSlider.maximunValue = 4
        analysisSlider.currentValue = 1
        analysisSliderValueChanged(analysisSlider)
        analysisSlider.addTarget(self, action: #selector(self.analysisSliderValueChanged), forControlEvents: .ValueChanged)
        analysisView.addSubview(analysisSlider)
        
        statsSlider.frame = CGRect(x: rangeSliderMargin, y: 63, width: rangeSliderWidth, height: rangeSliderHeight)
        statsSlider.showPoint = true
        statsSlider.minimunValue = 1
        statsSlider.maximunValue = 4
        statsSlider.currentValue = 1
        statsSliderValueChange(statsSlider)
        statsSlider.addTarget(self, action: #selector(self.statsSliderValueChange), forControlEvents: .ValueChanged)
        bestStatsView.addSubview(statsSlider)        
    }
    func analysisSliderValueChanged(rangeSlider: RangeSlider) {
        
    }
    func statsSliderValueChange(rangeSlider: RangeSlider) {
        
    }
   
    
   
    @IBAction func touchUpATKButton(sender: AnyObject) {
        ATKButton.isSelect = !ATKButton.isSelect
    }
    @IBAction func touchUpDEFButton(sender: AnyObject) {
        DEFButton.isSelect = !DEFButton.isSelect
    }
    @IBAction func touchUpSTAButton(sender: AnyObject) {
        STAButton.isSelect = !STAButton.isSelect
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