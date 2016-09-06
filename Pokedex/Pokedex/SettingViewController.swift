//
//  SettingViewController.swift
//  Pokedex
//
//  Created by Javan.Chen on 2016/8/25.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
 
    @IBOutlet weak var campScrollView: UIScrollView!
    @IBOutlet weak var campPageControl: UIPageControl!
    @IBOutlet weak var languageSegment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        campScrollView.delegate = self
        campScrollView.layoutIfNeeded()
        configureView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateTeamColor()
        updateLanguage()
    }
    private func configureView() {
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
        
        // initial page
        languageSegment.selectedSegmentIndex = userLang.hashValue
        campPageControl.currentPage = userTeam.hashValue
        campScrollView.contentOffset.x = campScrollView.frame.size.width * CGFloat(userTeam.hashValue)
    }
    @IBAction func languageSegmentValueChange(sender: AnyObject) {
        if let lang = Lang(rawValue: sender.selectedSegmentIndex) {
            userLang = lang
            updateLanguage()
            NSUserDefaults.standardUserDefaults().setInteger(userLang.hashValue, forKey: "userLang")
        }
    }
    
    // update team and language
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    func updateTeamColor() {
        switch userTeam {
        case .Instinct:
            languageSegment.tintColor = colorY
            backgroundView.backgroundColor = colorBGY
            self.navigationController?.navigationBar.barTintColor = colorY
        case .Mystic:
            languageSegment.tintColor = colorB
            backgroundView.backgroundColor = colorBGB
            self.navigationController?.navigationBar.barTintColor = colorB
        case .Valor:
            languageSegment.tintColor = colorR
            backgroundView.backgroundColor = colorBGR
            self.navigationController?.navigationBar.barTintColor = colorR
        }
    }
    func updateLanguage() {
        switch userLang {
        case .English:
            title = "Setting"
            teamLabel.text = "Team"
            languageLabel.text = "Language"
        case .Chinese, .Austrian:
            title = "設定"
            teamLabel.text = "陣營"
            languageLabel.text = "語言"
        }
    }
}

extension SettingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let currentPage = Float((scrollView.contentOffset.x) / width)
        campPageControl.currentPage = Int(currentPage)
        if Int(currentPage) != userTeam.hashValue {
            if let team = Team(rawValue: Int(currentPage)) {
                userTeam = team
                updateTeamColor()
                NSUserDefaults.standardUserDefaults().setInteger(userTeam.hashValue, forKey: "userTeam")
            }
        }
    }
}