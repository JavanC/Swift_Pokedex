//
//  TeachViewController.swift
//  Pokedex
//
//  Created by Javan on 2016/8/27.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

class TeachViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.layoutIfNeeded()
    }
    override func viewWillAppear(animated: Bool) {
        updateLanguage()
    }
    @IBAction func touchUpTeachDoneButton(sender: AnyObject) {
        hasTeach = true
        NSUserDefaults.standardUserDefaults().setBool(hasTeach, forKey: "hasTeach")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // update language
    @IBOutlet weak var page1TitleLabel: UILabel!
    @IBOutlet weak var page1Label: UILabel!
    @IBOutlet weak var page2TitleLabel: UILabel!
    @IBOutlet weak var page2Label: UILabel!
    @IBOutlet weak var page3TitleLabel: UILabel!
    @IBOutlet weak var page3Label: UILabel!
    @IBOutlet weak var page4TitleLabel: UILabel!
    @IBOutlet weak var page4Label: UILabel!
    @IBOutlet weak var teachDoneButton: UIButton!
    func updateLanguage() {
        switch userLang {
        case .English:
            page1TitleLabel.text = "WHAT ARE IV'S?"
            page1Label.text = "Each Pokemon in the game is unique. Not only does each distinct species have \"base\" stats for attack, defence, and stamina, but each individual Pokemon has additional unique values for those three stats. These are called \"Individual Values\" or IV's and range from 0-15 for each stat."
            page2TitleLabel.text = "HOW TO GET IV'S?"
            page2Label.text = "Step 1. Set your trainer level.\n\nStep 2. Slide the Arc Into position, you can double check CP, HP is in the range and needed for power up is correct.\n\nStep 3. Slide your pokemon current CP and HP value.\n\nAdvanced: If use \"Pro\" can correction correct level and accurate stats."
            page3TitleLabel.text = "GYM ABILITY?"
            page3Label.text = "Choose your \"Fast attack\" and \"Charge attack\", different combinations let you know that your ability to pekemon.\n\nAttack and Defensive damage are calculated from the Gym \"60 seconds\", touch the value you can see details. Default opponent is LV.20 Pikachu (IV Max)."
            page4TitleLabel.text = "THE FORMULA?"
            page4Label.text = "Become attacks: Charge attack Seconds +0.5\nBecome defend: All attacks Seconds +2.0, HP x 2\n\nDamage = Floor(½ Power * Attacker's_Attack/Defender's_Defense * STAB * Effectiveness)+ 1\nHere we'll ignore Effectiveness."
            teachDoneButton.setTitle("Okay, I get it!", forState: .Normal)
        case .Chinese, .Austrian:
            page1TitleLabel.text = "什麼是IV值？"
            page1Label.text = "每隻寶可夢，擁有該種類基礎的\"攻擊、防禦、體力\"值之外，這三種值每種還會再附加0-15的數值，就是所謂的IV值。\n\nCP值就是由當前寶可夢等級(曲線角度)，再由攻擊、防禦、體力值計算而來，強化一次使得你的寶可夢等級+0.5，當寶可夢相同等級(曲線角度)時，IV越高會使得計算出的CP值越高。"
            page2TitleLabel.text = "如何使用IV計算?"
            page2Label.text = "Step 1. 設定你的訓練師等級。\n\nStep 2. 滑動曲線至正確角度，你可以根據CP值及HP值是否在區間內，還有強化需求是否相同，來確認你的曲線角度是否在正確位置。\n\n Step 3. 輸入當前的CP值及HP值即可。\n\n進階計算: 點擊Pro可以結合隊長分析，修正正確等級與三項屬性。"
            page3TitleLabel.text = "道館攻守能力?"
            page3Label.text = "選擇\"快速攻擊\"及\"蓄力攻擊\"，不同的技能組合會影響你的寶可夢在進攻道館跟防守道館的能力。\n\n選擇後會立刻根據能力值及技能計算在進攻道館及防守道館\"60秒總傷害值\"，點擊數值可以查看詳細資訊，預設對手皆為 Lv.20 皮卡丘(IV Max)。"
            page4TitleLabel.text = "計算公式?"
            page4Label.text = "進攻方: 蓄力攻擊秒數+0.5\n防守方: 所有攻擊秒數+2.0，HP x 2\n\nDamage = Floor(½ Power * Attacker's_Attack/Defender's_Defense * STAB * Effectiveness)+ 1\n在此忽略Effectiveness影響。"
            teachDoneButton.setTitle("好的，我了解了！", forState: .Normal)
        }
    }
}

extension TeachViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let currentPage = Float((scrollView.contentOffset.x) / width)
        pageController.currentPage = Int(currentPage)
    }
}
