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
    @IBOutlet weak var teachDoneButton: UIButton!
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // update language
  
    @IBOutlet weak var page1TitleLabel: UILabel!
    @IBOutlet weak var page1Label: UILabel!
    @IBOutlet weak var page2TitleLabel: UILabel!
    @IBOutlet weak var page2Label: UILabel!
    @IBOutlet weak var page3TitleLabel: UILabel!
    @IBOutlet weak var page3Label: UILabel!
    func updateLanguage() {
        switch userLang {
        case .English:
            page1TitleLabel.text = "WHAT ARE IV'S?"
            page1Label.text = "Each Pokemon in the game is unique. Not only does each distinct species have \"base\" stats for attack, defence, and stamina, but each individual Pokemon has additional unique values for those three stats. These are called 'Individual Values' or IV's and range from 0-15 for each stat."
            page2TitleLabel.text = "HOW TO GET IV'S?"
            page2Label.text = "Step 1. Set your trainer level.\n\nStep 2. Slide the Arc Into position, you can double check CP, HP is in the range and needed for power up is correct. \n\nStep 3. Slide your pokemon current CP and HP value."
            page3TitleLabel.text = "MOVES ABILITY?"
            page3Label.text = "Different moves sets to let you know that this pokemon for attack or defense. Good mix of skills is key to attack and defend GYM.\n\nSelect your Fast attack and Charge attacks, will be calculated attack and defend damage at GYM for 60 seconds."
            
        case .Chinese, .Austrian:
            break
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