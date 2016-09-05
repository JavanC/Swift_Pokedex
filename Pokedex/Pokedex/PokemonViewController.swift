//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Javan.Chen on 2016/8/17.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PokemonViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var hideAdLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewInsideViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
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
    @IBOutlet weak var cpValueWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var hpValueWidthConstraint: NSLayoutConstraint!
    
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
    @IBOutlet weak var gymAttackValueButton: UIButton!
    @IBOutlet weak var gymDefendValueButton: UIButton!

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
        configureView()
        if !hasTeach { pushToTipController() }
    }
    override func viewWillAppear(animated: Bool) {
        updateTeamColor()
        updateLanguage()
    }
    
    func pushToTipController() {
        self.performSegueWithIdentifier("toTeachViewController", sender: self)
    }
    
    private func loadData() {
        let defaults = NSUserDefaults.standardUserDefaults()
        trainerLevel = defaults.doubleForKey("trainerLevel") != 0 ? defaults.doubleForKey("trainerLevel") : 20
    }
    
    private func configureView() {
        // for iPhone autolayout
        if UIScreen.mainScreen().bounds.height < 826 + 64 {
            let constant = 100 + UIScreen.mainScreen().bounds.width * 0.8 / 2
            pokemonInfoViewHeightConstraint.constant = constant
            scrollViewInsideViewHeightConstraint.constant = 596 + constant
            self.view.layoutIfNeeded()
        } else {
        // for iPad autolayout
            scrollView.scrollEnabled = false
            let constant = UIScreen.mainScreen().bounds.height - 64 - 596 - 50
            scrollViewInsideViewHeightConstraint.constant = 826 + (constant - 200)
            pokemonInfoViewHeightConstraint.constant = constant
            self.view.layoutIfNeeded()
        }

        // google mobile ad and hide ad Label
        self.bannerView.delegate = self
        self.bannerView.adUnitID = "ca-app-pub-6777277453719401/7684779573"
        self.bannerView.rootViewController = self
        hideAdLabel.layer.borderWidth = 1
        hideAdLabel.layer.borderColor = UIColor.whiteColor().CGColor
        // nas no teach, no ad time half hour
        if !hasTeach {
            print("has no teach, set no ad time 10 min")
            let now = NSDate(timeInterval: 600 - 86400, sinceDate: NSDate())
            NSUserDefaults.standardUserDefaults().setObject(now, forKey: "adDate")
        }
        // check ad time is over 24 hour
        let lastADDate = NSUserDefaults.standardUserDefaults().objectForKey("adDate") as? NSDate
        if let intervall = lastADDate?.timeIntervalSinceNow {
            let pastSeconds = -Int(intervall)
            print("ad past seconds: \(pastSeconds)")
            if pastSeconds <= 86400 {
                print("this time need No AD")
                showAdSpace(isShow: false)
            } else {
                print("this time need Show AD (if have network)")
                showAdSpace(isShow: true && Reachability.isConnectedToNetwork())
            }
        }
        
        // Initial navigation bar
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tips"), style: .Plain, target: self, action: #selector(pushToTipController))
    
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
        let rulerSliderHeight: CGFloat = 25
        var rulerSliderMargin: CGFloat = UIScreen.mainScreen().bounds.width * 0.1 - rulerSliderHeight / 2
        if UIScreen.mainScreen().bounds.height > 826 + 64 {
            rulerSliderMargin = UIScreen.mainScreen().bounds.width / 2 - pokemonImage.frame.width * 1.2 - rulerSliderHeight / 2
        }
        let rulerSliderWidth = view.bounds.width - 2.0 * rulerSliderMargin
        let pokemonInfoViewHeight = pokemonInfoView.frame.height
        levelRulerSlider.frame = CGRect(x: rulerSliderMargin, y: pokemonInfoViewHeight - rulerSliderHeight, width: rulerSliderWidth, height: rulerSliderHeight)
        let maxLevel = trainerLevel * 2 + 3 > 80 ? 80 : trainerLevel * 2 + 3
        levelRulerSlider.maximunValue = maxLevel
        levelRulerSlider.currentValue = Double(Int((maxLevel + 4) / 2))
        levelRulerSliderValueChanged(levelRulerSlider)
        levelRulerSlider.addTarget(self, action: #selector(self.levelRulerSliderValueChanged), forControlEvents: .ValueChanged)
        scrollView.addSubview(levelRulerSlider)
        
        // range slider
        let rangeSliderHeight: CGFloat = 25
        let rangeSliderMargin: CGFloat = UIScreen.mainScreen().bounds.width * 0.1 - rangeSliderHeight / 2
        let rangeSliderWidth = view.bounds.width - 2.0 * rangeSliderMargin
        pokemonCPSlider.frame = CGRect(x: rangeSliderMargin, y: 28, width: rangeSliderWidth, height: rangeSliderHeight)
        let cpCurrentValue = Double(Int((pokemonCPSlider.minimunValue + pokemonCPSlider.maximunValue) / 2))
        pokemonCPSlider.currentValue = cpCurrentValue
        cpRangeSliderValueChanged(pokemonCPSlider)
        pokemonCPSlider.addTarget(self, action: #selector(self.cpRangeSliderValueChanged), forControlEvents: .ValueChanged)
        CPHPView.addSubview(pokemonCPSlider)
        
        pokemonHPSlider.frame = CGRect(x: rangeSliderMargin, y: 78, width: rangeSliderWidth, height: rangeSliderHeight)
        let hpCurrentValue = Double(Int((pokemonHPSlider.minimunValue + pokemonHPSlider.maximunValue) / 2))
        pokemonHPSlider.currentValue = hpCurrentValue
        hpRangeSliderValueChanged(pokemonHPSlider)
        pokemonHPSlider.addTarget(self, action: #selector(self.hpRangeSliderValueChanged), forControlEvents: .ValueChanged)
        CPHPView.addSubview(pokemonHPSlider)
        
        // segmented
        fastAttackSegmented.layoutIfNeeded()
        fastAttackSegmented.removeAllSegments()
        for (index, fastAttack) in pokemon.fastAttacks.enumerate() {
            let attackName = fastAttack
            let segmementedWidth = fastAttackSegmented.frame.width
            let itemWidth = segmementedWidth / CGFloat(pokemon.fastAttacks.count) - 5
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
            let attackName = chargeAttack
            let segmementedWidth = chargeAttackSegmented.frame.width
            let itemWidth = segmementedWidth / CGFloat(pokemon.chargeAttacks.count) - 5
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
        let strokeColor = userTeam == .Instinct ? colorY : userTeam == .Mystic ? colorB : colorR
        ivValueCircleLayer.path = path.CGPath
        ivValueCircleLayer.lineWidth = 16
        ivValueCircleLayer.fillColor = UIColor.clearColor().CGColor
        ivValueCircleLayer.strokeColor = strokeColor.CGColor
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
        let textWidth = UILabel().textSize("\(Int(pokemon.cp))", font: UIFont(name: "Futura-Medium", size: 16)!).width
        cpValueWidthConstraint.constant = textWidth
        updateIVView()
        updateGymStrength()
    }
    
    func hpRangeSliderValueChanged(rangeSlider: RangeSlider) {
        pokemon.hp = rangeSlider.currentValue
        hpValueLabel.text = "\(Int(pokemon.hp))"
        let textWidth = UILabel().textSize("\(Int(pokemon.hp))", font: UIFont(name: "Futura-Medium", size: 16)!).width
        hpValueWidthConstraint.constant = textWidth
        updateIVView()
        updateGymStrength()
    }
    
    @IBAction func cpValueWriteButton(sender: AnyObject) {
        var title = "", message = "", cancel = "", ok = ""
        switch userLang {
        case .English:
            title = "POKEMON CP"
            message = "Type the current CP value\n(\(Int(pokemon.minCp)) - \(Int(pokemon.maxCp)))"
            cancel = "Cancel"
            ok = "OK"
        case .Chinese, .Austrian:
            title = "CP值"
            message = "請輸入當前的CP值\n(\(Int(pokemon.minCp)) - \(Int(pokemon.maxCp)))"
            cancel = "取消"
            ok = "確認"
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.placeholder = "CP"
            textField.keyboardType = .NumberPad
        }
        let cancelAction = UIAlertAction(title: cancel, style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title: ok, style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            if var cp = Double(((alertController.textFields?.first)! as UITextField).text!) {
                cp = min(max(cp, Double(self.pokemon.minCp)), Double(self.pokemon.maxCp))
                self.pokemonCPSlider.currentValue = cp
                self.cpRangeSliderValueChanged(self.pokemonCPSlider)
            }
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func hpValueWriteButton(sender: AnyObject) {
        var title = "", message = "", cancel = "", ok = ""
        switch userLang {
        case .English:
            title = "POKEMON HP"
            message = "Type the current HP value\n(\(Int(pokemon.minHp)) - \(Int(pokemon.maxHp)))"
            cancel = "Cancel"
            ok = "OK"
        case .Chinese, .Austrian:
            title = "HP值"
            message = "請輸入當前的HP值\n(\(Int(pokemon.minHp)) - \(Int(pokemon.maxHp)))"
            cancel = "取消"
            ok = "確認"
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.placeholder = "HP"
            textField.keyboardType = .NumberPad
        }
        let cancelAction = UIAlertAction(title: cancel, style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title: ok, style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            if var hp = Double(((alertController.textFields?.first)! as UITextField).text!) {
                hp = min(max(hp, Double(self.pokemon.minHp)), Double(self.pokemon.maxHp))
                self.pokemonHPSlider.currentValue = hp
                self.hpRangeSliderValueChanged(self.pokemonHPSlider)
            }
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
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
        let attack = FastAttacks[pokemon.fastAttacks[sender.selectedSegmentIndex]]!
        let power = pokemon.type.contains(attack.type) ? attack.damage * 1.25 : attack.damage
        let second = attack.duration
        let DPS = power / attack.duration
        let energy = attack.energy
        fastAttackTypeLabel.text = "\(attack.type)"
        fastAttackPowerLabel.text = power % 1 == 0 ? "\(Int(power))" : "\(power)"
        fastAttackSecondLabel.text = second % 1 == 0 ? "\(Int(second))" : "\(second)"
        fastAttackDPSLabel.text = DPS % 1 == 0 ? "\(Int(DPS))" : String(format: "%.1f", DPS)
        fastAttackEnergyLabel.text = energy % 1 == 0 ? "\(Int(energy))" : "\(energy)"
        updateGymStrength()
    }
    
    @IBAction func chargeAttackSegmentValueChange(sender: AnyObject) {
        let attack = ChargeAttacks[pokemon.chargeAttacks[sender.selectedSegmentIndex]]!
        let power = pokemon.type.contains(attack.type) ? attack.damage * 1.25 : attack.damage
        let second = attack.duration
        let DPS = power / attack.duration
        let energy = attack.energy
        chargeAttackTypeLabel.text = "\(attack.type)"
        chargeAttackPowerLabel.text = power % 1 == 0 ? "\(Int(power))" : "\(power)"
        chargeAttackSecondLabel.text = second % 1 == 0 ? "\(Int(second))" : "\(second)"
        chargeAttackDPSLabel.text = DPS % 1 == 0 ? "\(Int(DPS))" : String(format: "%.1f", DPS)
        chargeAttackEnergyLabel.text = energy % 1 == 0 ? "\(Int(energy))" : "\(energy)"
        updateGymStrength()
    }
    
    func updateGymStrength() {
        let fastAttack = FastAttacks[pokemon.fastAttacks[fastAttackSegmented.selectedSegmentIndex]]!
        let fastPower = pokemon.type.contains(fastAttack.type) ? fastAttack.damage * 1.25 : fastAttack.damage
        let chargeAttack = ChargeAttacks[pokemon.chargeAttacks[chargeAttackSegmented.selectedSegmentIndex]]!
        let chargePower = pokemon.type.contains(chargeAttack.type) ? chargeAttack.damage * 1.25 : chargeAttack.damage
        let att = (pokemon.baseAtt + pokemon.indiAtt) * pokemon.CPM
        let def = (108 + 15) * 0.59740001
        let fastDamage = Int(0.5 * fastPower * att / def) + 1
        let chargeDamage = Int(0.5 * chargePower * att / def) + 1
        
        var damage = 0
        var second = 0.0
        var energy = 0.0
        while(true) {
            if energy < chargeAttack.energy {
                second += fastAttack.duration
                if second > 60 { break }
                damage += fastDamage
                energy += fastAttack.energy
                energy = min(energy, 100)
            } else {
                second += chargeAttack.duration + 0.5
                if second > 60 { break }
                damage += chargeDamage
                energy -= chargeAttack.energy
            }
        }
        gymAttackValueButton.setTitle("\(damage)", forState: .Normal)
        damage = 0
        second = 0.0
        energy = 0.0
        while(true) {
            if energy < chargeAttack.energy {
                second += fastAttack.duration + 2.0
                if second > 60 { break }
                damage += fastDamage
                energy += fastAttack.energy
                energy = min(energy, 100)
            } else {
                second += chargeAttack.duration + 2.0
                if second > 60 { break }
                damage += chargeDamage
                energy -= chargeAttack.energy
            }
        }
        gymDefendValueButton.setTitle("\(damage)", forState: .Normal)
    }
    @IBAction func touchUpGymAttackValueButton(sender: AnyObject) {
        print("show attack details")
        let fastAttack = FastAttacks[pokemon.fastAttacks[fastAttackSegmented.selectedSegmentIndex]]!
        let fastPower = pokemon.type.contains(fastAttack.type) ? fastAttack.damage * 1.25 : fastAttack.damage
        let chargeAttack = ChargeAttacks[pokemon.chargeAttacks[chargeAttackSegmented.selectedSegmentIndex]]!
        let chargePower = pokemon.type.contains(chargeAttack.type) ? chargeAttack.damage * 1.25 : chargeAttack.damage
        let att = (pokemon.baseAtt + pokemon.indiAtt) * pokemon.CPM
        let def = (108 + 15) * 0.59740001
        let fastDamage = Int(0.5 * fastPower * att / def) + 1
        let chargeDamage = Int(0.5 * chargePower * att / def) + 1
        
        var damage = 0
        var fastTime = 0
        var chargeTime = 0
        var second = 0.0
        var energy = 0.0
        while(true) {
            if energy < chargeAttack.energy {
                second += fastAttack.duration
                if second > 60 { break }
                damage += fastDamage
                energy += fastAttack.energy
                energy = min(energy, 100)
                fastTime += 1
            } else {
                second += chargeAttack.duration + 0.5
                if second > 60 { break }
                damage += chargeDamage
                energy -= chargeAttack.energy
                chargeTime += 1
            }
        }
        
        var title = "", message = "", confirm = ""
        switch userLang {
        case .English:
            title = "Attack Details"
            message = "Battle with Lv.20 Pikachu\nFast Attack Damage: \(fastDamage)\tTimes: \(fastTime)\nCharge Attack Damage: \(chargeDamage)\tTimes: \(chargeTime)\n60 seconds total damage: \(damage)"
            confirm = "OK"
        case .Chinese, .Austrian:
            title = "進攻數據"
            message = "對戰 Lv.20 皮卡丘\n快速攻擊傷害: \(fastDamage)\t次數: \(fastTime)\n蓄力攻擊傷害: \(chargeDamage)\t次數: \(chargeTime)\n60秒總傷害: \(damage)"
            confirm = "確認"
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: confirm, style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    @IBAction func touchUpGymDefendValueButton(sender: AnyObject) {
        let fastAttack = FastAttacks[pokemon.fastAttacks[fastAttackSegmented.selectedSegmentIndex]]!
        let fastPower = pokemon.type.contains(fastAttack.type) ? fastAttack.damage * 1.25 : fastAttack.damage
        let chargeAttack = ChargeAttacks[pokemon.chargeAttacks[chargeAttackSegmented.selectedSegmentIndex]]!
        let chargePower = pokemon.type.contains(chargeAttack.type) ? chargeAttack.damage * 1.25 : chargeAttack.damage
        let att = (pokemon.baseAtt + pokemon.indiAtt) * pokemon.CPM
        let def = (108 + 15) * 0.59740001
        let fastDamage = Int(0.5 * fastPower * att / def) + 1
        let chargeDamage = Int(0.5 * chargePower * att / def) + 1
        
        var damage = 0
        var fastTime = 0
        var chargeTime = 0
        var second = 0.0
        var energy = 0.0
        while(true) {
            if energy < chargeAttack.energy {
                second += fastAttack.duration + 2.0
                if second > 60 { break }
                damage += fastDamage
                energy += fastAttack.energy
                energy = min(energy, 100)
                fastTime += 1
            } else {
                second += chargeAttack.duration + 2.0
                if second > 60 { break }
                damage += chargeDamage
                energy -= chargeAttack.energy
                chargeTime += 1
            }
        }
        
        var title = "", message = "", confirm = ""
        switch userLang {
        case .English:
            title = "Defend Details"
            message = "Battle with Lv.20 Pikachu\nFast Attack Damage: \(fastDamage)\tTimes: \(fastTime)\nCharge Attack Damage: \(chargeDamage)\tTimes: \(chargeTime)\n60 seconds total damage: \(damage)"
            confirm = "OK"
        case .Chinese, .Austrian:
            title = "防守數據"
            message = "對戰 Lv.20 皮卡丘\n快速攻擊傷害: \(fastDamage)\t次數: \(fastTime)\n蓄力攻擊傷害: \(chargeDamage)\t次數: \(chargeTime)\n60秒總傷害: \(damage)"
            confirm = "確認"
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: confirm, style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    var isLeaveApplicationThisPage = false
    func adViewWillLeaveApplication(bannerView: GADBannerView!) {
        isLeaveApplicationThisPage = true
        // touch ad
        print("has touch ad")
        showAdSpace(isShow: false)
        
        // save new ad date
        print("reset ad time")
        let defaults = NSUserDefaults.standardUserDefaults()
        let now = NSDate(timeInterval: 0, sinceDate: NSDate())
        defaults.setObject(now, forKey: "adDate")
    }
    
    func showAdSpace(isShow isShow: Bool) {
        if isShow { self.bannerView.loadRequest(GADRequest()) }
        if UIScreen.mainScreen().bounds.height > 826 + 64 && !isLeaveApplicationThisPage{
            var constant = UIScreen.mainScreen().bounds.height - 64 - 596
            constant = isShow ? constant - 50 : constant
            scrollViewInsideViewHeightConstraint.constant = 826 + (constant - 200)
            pokemonInfoViewHeightConstraint.constant = constant
            pokemonInfoView.layoutIfNeeded()
        }
        scrollViewBottomConstraint.constant = isShow ? 50 : 0
        bannerView.hidden = isShow ? false : true
        hideAdLabel.hidden = isShow ? false : true
    }
    
    // update team and language
    @IBOutlet weak var trainerLevelTitleLabel: UILabel!
    @IBOutlet weak var estimatedLevelTitleLabel: UILabel!
    @IBOutlet weak var powerUpTitleLabel: UILabel!
    @IBOutlet weak var stardustTitleLabel: UILabel!
    @IBOutlet weak var candyTitleLabel: UILabel!
    @IBOutlet weak var pokemonCPTitleLabel: UILabel!
    @IBOutlet weak var pokemonCPTitleWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var pokemonHPTitleLabel: UILabel!
    @IBOutlet weak var pokemonHPTitleWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var proButton: UIButton!
    @IBOutlet weak var fastAttacksTitleLabel: UILabel!
    @IBOutlet weak var fastAttackTypeTitleLabel: UILabel!
    @IBOutlet weak var fastAttackPowerTitleLabel: UILabel!
    @IBOutlet weak var fastAttackSecondTitleLabel: UILabel!
    @IBOutlet weak var fastAttackDPSTitleLabel: UILabel!
    @IBOutlet weak var fastAttackEnergyTitleLabel: UILabel!
    @IBOutlet weak var chargeAttacksTitleLabel: UILabel!
    @IBOutlet weak var chargeAttackTypeTitleLabel: UILabel!
    @IBOutlet weak var chargeAttackPowerTitleLabel: UILabel!
    @IBOutlet weak var chargeAttackSecondTitleLabel: UILabel!
    @IBOutlet weak var chargeAttackDPSTitleLabel: UILabel!
    @IBOutlet weak var chargeAttackEnergyTitleLabel: UILabel!
    @IBOutlet weak var GYMPowerTitleLabel: UILabel!
    @IBOutlet weak var GYMAttackTitleLabel: UILabel!
    @IBOutlet weak var GYMDefendTitleLabel: UILabel!
    func updateTeamColor() {
        switch userTeam {
        case .Instinct:
            levelRulerSlider.thubTintColor = colorY
            pokemonCPSlider.trackTintColor = colorY
            pokemonHPSlider.trackTintColor = colorY
            proButton.tintColor = colorY
            fastAttackSegmented.tintColor = colorY
            chargeAttackSegmented.tintColor = colorY
            self.navigationController?.navigationBar.barTintColor = colorY
        case .Mystic:
            levelRulerSlider.thubTintColor = colorB
            pokemonCPSlider.trackTintColor = colorB
            pokemonHPSlider.trackTintColor = colorB
            proButton.tintColor = colorB
            fastAttackSegmented.tintColor = colorB
            chargeAttackSegmented.tintColor = colorB
            self.navigationController?.navigationBar.barTintColor = colorB
        case .Valor:
            levelRulerSlider.thubTintColor = colorR
            pokemonCPSlider.trackTintColor = colorR
            pokemonHPSlider.trackTintColor = colorR
            proButton.tintColor = colorR
            fastAttackSegmented.tintColor = colorR
            chargeAttackSegmented.tintColor = colorR
            self.navigationController?.navigationBar.barTintColor = colorR
        }
    }
    func updateLanguage() {
        title = pokemon.name[userLang.hashValue]
        switch userLang {
        case .English:
            hideAdLabel.text = "X Click to hide Ad 24 hour"
            trainerLevelTitleLabel.text = "TRAINER LEVEL"
            estimatedLevelTitleLabel.text = "ESTIMATED LEVEL"
            powerUpTitleLabel.text = "POWER UP"
            stardustTitleLabel.text = "STARDUST"
            candyTitleLabel.text = "CANDY"
            pokemonCPTitleLabel.text = "POKEMON CP"
            pokemonCPTitleWidthConstraint.constant = 120
            pokemonHPTitleLabel.text = "POKEMON HP"
            pokemonHPTitleWidthConstraint.constant = 120
            fastAttacksTitleLabel.text = "Fast Attacks"
            fastAttackTypeTitleLabel.text = "TYPE"
            fastAttackPowerTitleLabel.text = "POWER"
            fastAttackSecondTitleLabel.text = "SECOND"
            fastAttackDPSTitleLabel.text = "DPS"
            fastAttackEnergyTitleLabel.text = "ENERGY"
            chargeAttacksTitleLabel.text = "Charge Attacks"
            chargeAttackTypeTitleLabel.text = "TYPE"
            chargeAttackPowerTitleLabel.text = "POWER"
            chargeAttackSecondTitleLabel.text = "SECOND"
            chargeAttackDPSTitleLabel.text = "DPS"
            chargeAttackEnergyTitleLabel.text = "ENERGY"
            GYMPowerTitleLabel.text = "GYM STRENGTH"
            GYMAttackTitleLabel.text = "ATTACK"
            GYMDefendTitleLabel.text = "DEFEND"
        case .Chinese, .Austrian:
            hideAdLabel.text = "X 點擊可以隱藏廣告24小時"
            trainerLevelTitleLabel.text = "訓練師等級"
            estimatedLevelTitleLabel.text = "預估等級"
            powerUpTitleLabel.text = "強化需求"
            stardustTitleLabel.text = "星塵"
            candyTitleLabel.text = "糖果"
            pokemonCPTitleLabel.text = "當前CP值"
            pokemonCPTitleWidthConstraint.constant = 80
            pokemonHPTitleLabel.text = "當前HP值"
            pokemonHPTitleWidthConstraint.constant = 80
            fastAttacksTitleLabel.text = "快速攻擊"
            fastAttackTypeTitleLabel.text = "屬性"
            fastAttackPowerTitleLabel.text = "傷害"
            fastAttackSecondTitleLabel.text = "攻速"
            fastAttackDPSTitleLabel.text = "秒傷"
            fastAttackEnergyTitleLabel.text = "能量"
            chargeAttacksTitleLabel.text = "蓄力攻擊"
            chargeAttackTypeTitleLabel.text = "屬性"
            chargeAttackPowerTitleLabel.text = "傷害"
            chargeAttackSecondTitleLabel.text = "攻速"
            chargeAttackDPSTitleLabel.text = "秒傷"
            chargeAttackEnergyTitleLabel.text = "能量"
            GYMPowerTitleLabel.text = "道館攻守傷害"
            GYMAttackTitleLabel.text = "攻擊方"
            GYMDefendTitleLabel.text = "防守方"
        }
    }
}

extension PokemonViewController: pokemonDelegate{
    
    // pro iv calculate
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProIVViewController" {
            let controller = segue.destinationViewController as! ProIVViewController
            controller.pokemon = pokemon
            controller.delegate = self
        }
    }
    
    func sendPokemonData(pokemon: Pokemon) {
        self.pokemon = pokemon
        print(pokemon.cp)
    }
}