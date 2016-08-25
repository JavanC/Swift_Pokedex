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
        campScrollView.pagingEnabled = true
        campScrollView.layoutIfNeeded()
        configureView()
    }
    private func configureView() {
        languageSegment.selectedSegmentIndex = userLang.hashValue
        campPageControl.currentPage = userTeam.hashValue
        campScrollView.contentOffset.x = campScrollView.frame.size.width * CGFloat(userTeam.hashValue)
    }
    @IBAction func languageSegmentValueChange(sender: AnyObject) {
        if let lang = Lang(rawValue: sender.selectedSegmentIndex) {
            userLang = lang
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
            }
        }
    }
}