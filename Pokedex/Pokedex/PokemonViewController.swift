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
    @IBOutlet weak var favoriteButton: UIButton!
    
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
    
    @IBOutlet weak var gymBattleLabel: UILabel!
    @IBOutlet weak var gymOpponentButton: UIButton!
    @IBOutlet weak var gymAttackValueButton: UIButton!
    @IBOutlet weak var gymDefendValueButton: UIButton!

    @IBOutlet weak var typeView: MyCustomView!
    @IBOutlet weak var pokemonType1Image: UIImageView!
    @IBOutlet weak var pokemonType2Image: UIImageView!
    @IBOutlet weak var suggestAttackerView: MyCustomView!
    @IBOutlet weak var suggestAttackerViewHeightConstraint: NSLayoutConstraint!
    
    let levelRulerSlider = RulerSlider(frame: CGRectZero)
    let pokemonCPSlider = RangeSlider(frame: CGRectZero)
    let pokemonHPSlider = RangeSlider(frame: CGRectZero)
    let ivValueCircleLayer = CAShapeLayer()
    let cpValueArcLayer = CAShapeLayer()
    
    var pokemon: Pokemon!
    var opponent: Pokemon!
    var favoritePokemonIndex: Int!
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
        if isShowFavorite {
            loadFavoriteData()
        } else {
            loadData()
            configureView()
        }
        if !hasTeach { pushToTipController() }
    }
    override func viewWillAppear(animated: Bool) {
        updateTeamColor()
        updateLanguage()
    }
    override func viewWillDisappear(animated: Bool) {
        if favoriteButton.selected {
            favoritePokemonData[favoritePokemonIndex] = pokemon
        }
    }
    
    func pushToTipController() {
        self.performSegueWithIdentifier("toTeachViewController", sender: self)
    }
    
    private func loadFavoriteData() {
        let level = pokemon.level
        let cp = pokemon.cp
        let hp = pokemon.hp
        let indiAtk = pokemon.indiAtk
        let indiDef = pokemon.indiDef
        let indiSta = pokemon.indiSta
        let fastAttackNumber = pokemon.fastAttackNumber
        let chargeAttackNumber = pokemon.chargeAttackNumber
        
        loadData()
        configureView()
        
        levelRulerSlider.currentValue = level * 2
        levelRulerSliderValueChanged(levelRulerSlider)
        pokemonCPSlider.currentValue = cp
        cpRangeSliderValueChanged(pokemonCPSlider)
        pokemonHPSlider.currentValue = Double(hp)
        hpRangeSliderValueChanged(pokemonHPSlider)
        pokemon.indiAtk = indiAtk
        pokemon.indiDef = indiDef
        pokemon.indiSta = indiSta
        let persent = (indiAtk + indiDef + indiSta) / 45
        attDefValueLabel.text = indiAtk != indiDef ? "\(Int(indiAtk))+\(Int(indiDef)) / 30" : "\(Int(indiAtk + indiDef)) / 30"
        staValueLabel.text = "\(Int(indiSta)) / 15"
        ivValueLabel.text = "\(Int(persent * 100))%"
        ivValueCircleLayer.strokeEnd = CGFloat(persent)
        
        fastAttackSegmented.selectedSegmentIndex = fastAttackNumber
        fastAttackSegmentValueChange(fastAttackSegmented)
        chargeAttackSegmented.selectedSegmentIndex = chargeAttackNumber
        chargeAttackSegmentValueChange(chargeAttackSegmented)
    }
    
    private func loadData() {        
        let defaults = NSUserDefaults.standardUserDefaults()
        trainerLevel = defaults.doubleForKey("trainerLevel") != 0 ? defaults.doubleForKey("trainerLevel") : 20
        
        // initial opponent
        sendOpponentData(opponent)
    }
    
    private func configureView() {

        // iPhone
        var constant = 100 + UIScreen.mainScreen().bounds.width * 0.8 / 2
        // iPad
        if UIScreen.mainScreen().bounds.width > 640 {
            constant = UIScreen.mainScreen().bounds.height - 64 - 626
        }
        pokemonInfoViewHeightConstraint.constant = constant
        scrollViewInsideViewHeightConstraint.constant = 626 + 159 + constant
        self.view.layoutIfNeeded()

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
                showAdSpace(false)
            } else {
                print("this time need Show AD (if have network)")
                showAdSpace(true && Reachability.isConnectedToNetwork())
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
        
        // pokemonImage and favorite button
        pokemonImage.image = UIImage(named: pokemon.number)
        favoriteButton.selected = isShowFavorite
        
        // cp value arc
        drawCPValueArc()
        
        // iv value circle
        drawIVValueCircle()
        
        // ruler slider
        let rulerSliderHeight: CGFloat = 25
        var rulerSliderMargin: CGFloat = UIScreen.mainScreen().bounds.width * 0.1 - rulerSliderHeight / 2
        if UIScreen.mainScreen().bounds.width > 640 {
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
            let attackName = fastAttack.name
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
            let attackName = chargeAttack.name
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
        
        // Type view
        if pokemon.type.count == 1 {
            pokemonType1Image.hidden = true
            pokemonType2Image.image = UIImage(named: "\(pokemon.type[0])_icon")
        } else {
            pokemonType1Image.image = UIImage(named: "\(pokemon.type[0])_icon")
            pokemonType2Image.image = UIImage(named: "\(pokemon.type[1])_icon")
        }
        // [[week2x], [week], [resi], [resi2x]]
        var typeEffecArrays = Array(count: 4, repeatedValue: [Type]())
        for i in (0...17) {
            let attackType = Type(rawValue: i)!
            let effec = effectiveness(attackType, pokemonTypes: pokemon.type)
            if effec == 1.25 * 1.25 { typeEffecArrays[0].append(attackType) }
            if effec == 1.25        { typeEffecArrays[1].append(attackType) }
            if effec == 0.8         { typeEffecArrays[2].append(attackType) }
            if effec == 0.8 * 0.8   { typeEffecArrays[3].append(attackType) }
        }
        for (row, typeEffecArray) in typeEffecArrays.enumerate() {
            let count = typeEffecArray.count
            let width = count * 30
            let view = UIView(frame: CGRect(x: (Int(typeView.frame.width) - width) / 2, y: 40 + 30 * row, width: width, height: 30))
            for (row, type) in typeEffecArray.enumerate() {
                let image = UIImageView(image: UIImage(named: "\(type)_icon"))
                image.frame = CGRect(x: 2 + 30 * row, y: 2, width: 26, height: 26)
                view.addSubview(image)
            }
            typeView.addSubview(view)
        }
        
        // suggest attackers
        let exclude = ["#132", "#144", "#145", "#146", "#150", "#151"]
        let excludeStats: Double = 354
        var suggestSuperAttackers = [Pokemon]()
        for pokemon in pokemonData {
            if exclude.contains(pokemon.number) { continue }
            if (pokemon.baseAtt + pokemon.baseDef + pokemon.baseSta) <= excludeStats { continue }
            var appendFlag = false
            for type in typeEffecArrays[0] {
                if pokemon.type.contains(type) {
                    for fastAttack in pokemon.fastAttacks {
                        if fastAttack.type == type {
                            appendFlag = true
                        }
                    }
                    for chargeAttack in pokemon.chargeAttacks {
                        if chargeAttack.type == type {
                            appendFlag = true
                        }
                    }
                }
            }
            if appendFlag {
                suggestSuperAttackers.append(pokemon)
            }
        }
        var suggestAttackers = [Pokemon]()
        for pokemon in pokemonData {
            if exclude.contains(pokemon.number) { continue }
            if (pokemon.baseAtt + pokemon.baseDef + pokemon.baseSta) <= excludeStats { continue }
            if typeEffecArrays[0].contains(pokemon.type[0]) { continue }
            if pokemon.type.count == 2 && typeEffecArrays[0].contains(pokemon.type[1]) { continue }
            var appendFlag = false
            for type in typeEffecArrays[1] {
                if pokemon.type.contains(type) {
                    for fastAttack in pokemon.fastAttacks {
                        if fastAttack.type == type {
                            appendFlag = true
                        }
                    }
                    for chargeAttack in pokemon.chargeAttacks {
                        if chargeAttack.type == type {
                            appendFlag = true
                        }
                    }
                }
            }
            for fastAttack in pokemon.fastAttacks {
                if typeEffecArrays[0].contains(fastAttack.type) {
                    appendFlag = true
                }
            }
            for chargeAttack in pokemon.chargeAttacks {
                if typeEffecArrays[0].contains(chargeAttack.type) {
                    appendFlag = true
                }
            }
            if appendFlag {
                suggestAttackers.append(pokemon)
            }
        }
        suggestSuperAttackers.sortInPlace { (pokemon1, pokemon2) -> Bool in
            let pokemon1Base = pokemon1.baseAtt + pokemon1.baseDef + pokemon1.baseSta
            let pokemon2Base = pokemon2.baseAtt + pokemon2.baseDef + pokemon2.baseSta
            return pokemon1Base > pokemon2Base
        }
        suggestAttackers.sortInPlace { (pokemon1, pokemon2) -> Bool in
            let pokemon1Base = pokemon1.baseAtt + pokemon1.baseDef + pokemon1.baseSta
            let pokemon2Base = pokemon2.baseAtt + pokemon2.baseDef + pokemon2.baseSta
            return pokemon1Base > pokemon2Base
        }
        
        let isIpad = UIScreen.mainScreen().bounds.width > 640
        scrollViewInsideViewHeightConstraint.constant = scrollViewInsideViewHeightConstraint.constant + (isIpad ? 154 : 264)
        suggestAttackerViewHeightConstraint.constant = isIpad ? 155 : 265
        let showNumber = Int(UIScreen.mainScreen().bounds.width / 80)
        let gap = (UIScreen.mainScreen().bounds.width - 80 * CGFloat(showNumber)) / CGFloat(showNumber + 1)
        let suggestPokemons = suggestSuperAttackers + suggestAttackers
        for (index, pokemon) in suggestPokemons.enumerate() {
            if index == showNumber * (isIpad ? 1 : 2) { break }
            let x = gap * CGFloat(index % showNumber + 1) + 80 * CGFloat(index % showNumber)
            let y: CGFloat = index > showNumber - 1 ? 150 : 40
            let view = UIView(frame: CGRect(x: x, y: y, width: 80, height: 110))
            let image = UIImageView(image: UIImage(named: pokemon.number))
            image.frame = CGRect(x: 10, y: 0, width: 60, height: 60)
            view.addSubview(image)
            var types = [Type]()
            let effectTypes = typeEffecArrays[0] + typeEffecArrays[1]
            if effectTypes.contains(pokemon.type[0]) {
                types.append(pokemon.type[0])
            }
            if pokemon.type.count == 2 && effectTypes.contains(pokemon.type[1]) {
                types.append(pokemon.type[1])
            }
            for (index, type) in types.enumerate() {
                let type1Image = UIImageView(image: UIImage(named: "\(type)_icon"))
                type1Image.frame = CGRect(x: 2, y: 10 + index * 10, width: 10, height: 10)
                view.addSubview(type1Image)
            }
            var attacks = [Attack]()
            for fastAttack in pokemon.fastAttacks {
                if effectTypes.contains(fastAttack.type) {
                    attacks.append(fastAttack)
                }
            }
            for chargeAttack in pokemon.chargeAttacks {
                if effectTypes.contains(chargeAttack.type) {
                    attacks.append(chargeAttack)
                }
            }
            for (index, attack) in attacks.enumerate() {
                let typeImage = UIImageView(image: UIImage(named: "\(attack.type)_icon"))
                typeImage.frame = CGRect(x: 2, y: 60 + index * 10, width: 10, height: 10)
                view.addSubview(typeImage)
                let label = UILabel(frame: CGRect(x: 14, y: 60 + index * 10, width: 66, height: 10))
                label.font = UIFont(name: "Futura-Medium", size: 8)
                label.text = attack.name
                label.textColor = UIColor.darkGrayColor()
                view.addSubview(label)
            }
            suggestAttackerView.addSubview(view)
        }
    }
    
    private func drawCPValueArc() {
        let arcCenter = CGPoint(x: view.bounds.width / 2, y: pokemonInfoView.bounds.height - 28)
        let StartAngel: CGFloat = CGFloat(M_PI)
        let EndAngel: CGFloat = 0
        let Radius: CGFloat = UIScreen.mainScreen().bounds.width > 640 ? pokemonImage.frame.width * 1.2 : view.bounds.width * 0.4
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
        let strokeColor = teamColor(alpha: 1)
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
    @IBAction func touchUpFavoriteButton(sender: AnyObject) {
        favoriteButton.selected = !favoriteButton.selected
        if favoriteButton.selected {
            favoritePokemonData.append(pokemon)
            favoritePokemonIndex = favoritePokemonData.count - 1
        } else {
            favoritePokemonData.removeAtIndex(favoritePokemonIndex)
        }
    }
    
    func levelRulerSliderValueChanged(rulerSlider: RulerSlider) {
        pokemon.level = rulerSlider.currentValue / 2
        estimatedLevelLabel.text = pokemon.level % 1 == 0 ? "\(Int(pokemon.level))" : "\(pokemon.level)"
        stardustLabel.text = "\(Int(pokemon.stardust))"
        candyLabel.text = "\(Int(pokemon.candy))"
        
        hpRangeValueLabel.text = "\(Int(pokemon.minHp))-\(Int(pokemon.maxHp))"
        hpRangeValueLabel2.text = "\(Int(pokemon.minHp)) - \(Int(pokemon.maxHp))"
        pokemonHPSlider.minimunValue = Double(pokemon.minHp)
        pokemonHPSlider.maximunValue = Double(pokemon.maxHp)
        pokemonHPSlider.currentValue = Double(pokemon.hp)
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
        pokemon.hp = Int(rangeSlider.currentValue)
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
        let attDef = pokemon.indiAtk + pokemon.indiDef
        let sta = pokemon.indiSta
        let persent = (attDef + sta) / 45
        attDefValueLabel.text = "\(Int(attDef)) / 30"
        staValueLabel.text = "\(Int(sta)) / 15"
        ivValueLabel.text = "\(Int(persent * 100))%"
        ivValueCircleLayer.strokeEnd = CGFloat(persent)
    }
    
    @IBAction func fastAttackSegmentValueChange(sender: AnyObject) {
        pokemon.fastAttackNumber = sender.selectedSegmentIndex
        let attack = pokemon.fastAttacks[sender.selectedSegmentIndex]
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
        pokemon.chargeAttackNumber = sender.selectedSegmentIndex
        let attack = pokemon.chargeAttacks[sender.selectedSegmentIndex]
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
        var attackDetail = battle(pokemon, defender: opponent, stopTrigger: 1)
        var defendDetail = battle(opponent, defender: pokemon, stopTrigger: 2)
        for fastNumber in 0...opponent.fastAttacks.count - 1 {
            for chargeNumber in 0...opponent.chargeAttacks.count - 1 {
                opponent.fastAttackNumber = fastNumber
                opponent.chargeAttackNumber = chargeNumber
                let A_detail = battle(pokemon, defender: opponent, stopTrigger: 1)
                if A_detail.percent < attackDetail.percent {
                    attackDetail = A_detail
                }
                let D_detail = battle(opponent, defender: pokemon, stopTrigger: 2)
                if D_detail.percent < defendDetail.percent {
                    defendDetail = D_detail
                }
            }
        }
        gymAttackValueButton.setTitle("\(attackDetail.percent)", forState: .Normal)
        gymDefendValueButton.setTitle("\(defendDetail.percent)", forState: .Normal)
    }
    
    @IBAction func touchUpGymAttackValueButton(sender: AnyObject) {
        print("show attack details")
        var attackDetail = battle(pokemon, defender: opponent, stopTrigger: 1)
        for fastNumber in 0...opponent.fastAttacks.count - 1 {
            for chargeNumber in 0...opponent.chargeAttacks.count - 1 {
                opponent.fastAttackNumber = fastNumber
                opponent.chargeAttackNumber = chargeNumber
                let A_detail = battle(pokemon, defender: opponent, stopTrigger: 1)
                if A_detail.percent < attackDetail.percent {
                    attackDetail = A_detail
                }
            }
        }
        
        var title = "", message = "", confirm = ""
        switch userLang {
        case .English:
            title = "Attack Details"
            message = "Battle with CP \(Int(opponent.cp)) \(opponent.name[0])\nFight \(String(format: "%.1f", attackDetail.battleTime)) seconds before you die\n\nFast Attack Damage: \(attackDetail.fastDamage) Times: \(attackDetail.fastTime)\nCharge Attack Damage: \(attackDetail.chargeDamage) Times: \(attackDetail.chargeTime)\nTotal damage: \(attackDetail.totalDamage)(opponent \(attackDetail.percent)% HP)"
            confirm = "OK"
        case .Chinese, .Austrian:
            title = "進攻數據"
            message = "對戰 CP \(Int(opponent.cp)) \(opponent.name[1])\n血量歸零前戰鬥 \(String(format: "%.1f", attackDetail.battleTime)) 秒\n\n快速攻擊傷害: \(attackDetail.fastDamage) 次數: \(attackDetail.fastTime)\n蓄力攻擊傷害: \(attackDetail.chargeDamage) 次數: \(attackDetail.chargeTime)\n總傷害: \(attackDetail.totalDamage) (對手 \(attackDetail.percent)% HP)"
            confirm = "確認"
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: confirm, style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    @IBAction func touchUpGymDefendValueButton(sender: AnyObject) {
        print("show Defend details")
        var defendDetail = battle(opponent, defender: pokemon, stopTrigger: 2)
        for fastNumber in 0...opponent.fastAttacks.count - 1 {
            for chargeNumber in 0...opponent.chargeAttacks.count - 1 {
                opponent.fastAttackNumber = fastNumber
                opponent.chargeAttackNumber = chargeNumber
                let D_detail = battle(opponent, defender: pokemon, stopTrigger: 2)
                if D_detail.percent < defendDetail.percent {
                    defendDetail = D_detail
                }
            }
        }
    
        var title = "", message = "", confirm = ""
        switch userLang {
        case .English:
            title = "Defend Details"
            message = "Battle with CP \(Int(opponent.cp)) \(opponent.name[0])\nFight \(String(format: "%.1f", defendDetail.battleTime)) seconds before you die\n\nFast Attack Damage: \(defendDetail.fastDamage) Times: \(defendDetail.fastTime)\nCharge Attack Damage: \(defendDetail.chargeDamage) Times: \(defendDetail.chargeTime)\nTotal damage: \(defendDetail.totalDamage)(opponent \(defendDetail.percent)% HP)"
            confirm = "OK"
        case .Chinese, .Austrian:
            title = "防守數據"
            message = "對戰 CP \(Int(opponent.cp)) \(opponent.name[1])\n血量歸零前戰鬥 \(String(format: "%.1f", defendDetail.battleTime)) 秒\n\n快速攻擊傷害: \(defendDetail.fastDamage) 次數: \(defendDetail.fastTime)\n蓄力攻擊傷害: \(defendDetail.chargeDamage) 次數: \(defendDetail.chargeTime)\n總傷害: \(defendDetail.totalDamage) (對手 \(defendDetail.percent)% HP)"
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
        showAdSpace(false)
        
        // save new ad date
        print("reset ad time")
        let defaults = NSUserDefaults.standardUserDefaults()
        let now = NSDate(timeInterval: 0, sinceDate: NSDate())
        defaults.setObject(now, forKey: "adDate")
    }
    
    func showAdSpace(isShow: Bool) {
        if isShow { self.bannerView.loadRequest(GADRequest()) }
        if UIScreen.mainScreen().bounds.height > 1016 + 64 && !isLeaveApplicationThisPage{
            var constant = UIScreen.mainScreen().bounds.height - 64 - 786
            constant = isShow ? constant - 50 : constant
            pokemonInfoViewHeightConstraint.constant = constant
            scrollViewInsideViewHeightConstraint.constant = 786 + constant
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
    @IBOutlet weak var GYMBattleBGView: MyCustomView!
    @IBOutlet weak var GYMAttackTitleLabel: UILabel!
    @IBOutlet weak var GYMDefendTitleLabel: UILabel!
    @IBOutlet weak var typeViewTitleLabel: UILabel!
    @IBOutlet weak var typeViewBG1: UIView!
    @IBOutlet weak var typeViewBG2: UIView!
    @IBOutlet weak var typeViewBG3: UIView!
    @IBOutlet weak var typeViewBG4: UIView!
    @IBOutlet weak var suggestAttackerTitleLabel: UILabel!
    func updateTeamColor() {
        navigationController?.navigationBar.barTintColor = teamColor(alpha: 1)
        levelRulerSlider.thubTintColor = teamColor(alpha: 1)
        pokemonCPSlider.trackTintColor = teamColor(alpha: 1)
        pokemonHPSlider.trackTintColor = teamColor(alpha: 1)
        proButton.tintColor = teamColor(alpha: 1)
        fastAttackSegmented.tintColor = teamColor(alpha: 1)
        chargeAttackSegmented.tintColor = teamColor(alpha: 1)
        GYMBattleBGView.borderColor = teamColor(alpha: 1)
        GYMBattleBGView.backgroundColor = teamColor(alpha: 0.7)
        typeViewBG1.backgroundColor = teamColor(alpha: 0.3)
        typeViewBG2.backgroundColor = teamColor(alpha: 0.25)
        typeViewBG3.backgroundColor = teamColor(alpha: 0.2)
        typeViewBG4.backgroundColor = teamColor(alpha: 0.15)
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
            typeViewTitleLabel.text = "WEAKNESS & STRENGTH"
            suggestAttackerTitleLabel.text = "SUGGEST ATTACKER"
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
            GYMPowerTitleLabel.text = "道館攻守表現"
            GYMAttackTitleLabel.text = "攻擊"
            GYMDefendTitleLabel.text = "防守"
            typeViewTitleLabel.text = "遭受攻擊加乘"
            suggestAttackerTitleLabel.text = "建議攻擊者&技能"
        }
    }
}

extension PokemonViewController: pokemonDelegate, OpponentDelegate{
    
    // pro iv calculate
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProIVViewController" {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            self.navigationItem.backBarButtonItem = backItem
            let controller = segue.destinationViewController as! ProIVViewController
            controller.pokemon = pokemon
            controller.delegate = self
        }
        if segue.identifier == "showBattleOpponentViewController" {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            self.navigationItem.backBarButtonItem = backItem
            let controller = segue.destinationViewController as! BattleOpponentViewController
            controller.delegate = self
        }
    }
    
    func sendPokemonData(pokemon: Pokemon) {
        self.pokemon = pokemon

        let level = pokemon.level
        let indiAtk = pokemon.indiAtk
        let indiDef = pokemon.indiDef
        let indiSta = pokemon.indiSta
        levelRulerSlider.currentValue = level * 2
        levelRulerSliderValueChanged(levelRulerSlider)
        self.pokemon.indiAtk = indiAtk
        self.pokemon.indiDef = indiDef
        self.pokemon.indiSta = indiSta
        
        let persent = (indiAtk + indiDef + indiSta) / 45
        attDefValueLabel.text = "\(Int(indiAtk))+\(Int(indiDef)) / 30"
        staValueLabel.text = "\(Int(indiSta)) / 15"
        ivValueLabel.text = "\(Int(persent * 100))%"
        ivValueCircleLayer.strokeEnd = CGFloat(persent)
        
        updateGymStrength()
    }
    
    func sendOpponentData(opponent: Pokemon) {
        self.opponent = opponent
        gymOpponentButton.setBackgroundImage(UIImage(named: opponent.number)!, forState: .Normal)
        switch userLang {
        case .English:
            gymBattleLabel.text = "Battle with cp \(Int(opponent.cp)) \(opponent.name[0])"
        case .Chinese:
            gymBattleLabel.text = "對戰 cp \(Int(opponent.cp)) \(opponent.name[1])"
        case .Austrian:
            gymBattleLabel.text = "對戰 cp \(Int(opponent.cp)) \(opponent.name[2])"
        }
        updateGymStrength()
    }
}
