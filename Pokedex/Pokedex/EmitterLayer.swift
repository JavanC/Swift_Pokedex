//
//  EmitterLayer.swift
//  Pokedex
//
//  Created by Javan.Chen on 2016/8/17.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

class EmitterLayer: CAEmitterLayer {

    init(rect: CGRect) {
        super.init()
        self.frame = rect
        self.emitterShape = kCAEmitterLayerRectangle
        //kCAEmitterLayerPoint
        //kCAEmitterLayerLine
        //kCAEmitterLayerRectangle
        self.emitterPosition = CGPointMake(rect.width/2, rect.height/2)
        self.emitterSize = rect.size
        //self.backgroundColor = UIColor.blackColor().CGColor           // 發射範圍背景顏色
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "spark")!.CGImage
        emitterCell.birthRate = 10                                      // 每秒產生10個粒子
        emitterCell.lifetime = 8                                        // 存活8秒
        emitterCell.lifetimeRange = 1.0                                 // 存活時間範圍 7 --- 9
        self.emitterCells = [emitterCell]                               // 這裡可以設置多種粒子 目前為一種
        emitterCell.yAcceleration = -5.0                                // Y方向加速度
        emitterCell.xAcceleration = 0.0                                 // X方向加速度
        emitterCell.velocity = 20.0                                     // 初始速度 20
        emitterCell.velocityRange = 5.0                                 // 速度範圍 15 --- 25
        emitterCell.emissionLongitude = CGFloat(M_PI_2 * 3)             // 發射方向向上
        emitterCell.emissionRange = CGFloat(M_PI_2)                     // 發射方向範圍 -pi/2 --- pi/2
        //emitterCell.color = UIColor(red: 0.9, green: 1.0, blue: 1.0, alpha: 1.0).CGColor //指定颜色
        //emitterCell.redRange = 0.3
        //emitterCell.greenRange = 0.3
        //emitterCell.blueRange = 0.3                                   // 三個隨機顏色
        emitterCell.scale = 0.2                                         // 初始大小
        emitterCell.scaleRange = 0.05                                   // 範圍大小 0.15 - 0.25
        emitterCell.scaleSpeed = -0.02                                  // 变小速度
        emitterCell.alphaRange = 0.75                                   // 随机透明度
        emitterCell.alphaSpeed = -0.1                                   // 透明速度
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
