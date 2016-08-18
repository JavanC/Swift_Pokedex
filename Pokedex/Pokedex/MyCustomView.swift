//
//  MyCustomView.swift
//  Pokedex
//
//  Created by Javan.Chen on 2016/8/18.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

@IBDesignable
class MyCustomView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
}
