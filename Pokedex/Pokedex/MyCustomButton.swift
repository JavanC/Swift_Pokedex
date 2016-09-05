//
//  MyCustomButton.swift
//  Poke Booklet
//
//  Created by Javan on 2016/9/5.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

class MyCustomButton: UIButton {
    var buttonColor: UIColor = colorY {
        didSet {
            self.borderColor = buttonColor
            self.tintColor = buttonColor
        }
    }
    var isSelect: Bool = false {
        didSet {
            if isSelect {
                self.backgroundColor = buttonColor
                self.tintColor = UIColor.whiteColor()
            } else {
                self.backgroundColor = UIColor.clearColor()
                self.tintColor = buttonColor
            }
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = colorY {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
}
