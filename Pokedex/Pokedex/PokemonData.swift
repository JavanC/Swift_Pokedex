//
//  PokemonData.swift
//  Pokedex
//
//  Created by Javan.Chen on 2016/8/17.
//  Copyright © 2016年 Javan. All rights reserved.
//

import Foundation

struct Pokemon {
    let number:String
    let name:String
    
    let baseAtt:Double
    let baseDef:Double
    let baseSta:Double
    var indiAtt:Double
    var indiDef:Double
    var indiSta:Double
    
    var CPM:Double
    var stardust:Double
    var candy:Double
    var minCp:Double
    var maxCp:Double
    var cp:Double {
        didSet {
            calculateIndiValue()
        }
    }
    var minHp:Double
    var maxHp:Double
    var hp:Double {
        didSet {
            calculateIndiValue()
        }
    }
    
    var level:Double {
        didSet {
            CPM = levelData[level]!["CPM"]!
            stardust = levelData[level]!["stardust"]!
            candy = levelData[level]!["Candies"]!
            
            minHp = Double(lround(baseSta * CPM > 10 ? baseSta * CPM : 10))
            maxHp = Double(lround((baseSta + 15) * CPM > 10 ? (baseSta + 15) * CPM : 10))
            hp = min(max(hp, minHp),maxHp)
            
            minCp = Double(lround(baseAtt * pow(baseDef,0.5) * pow(baseSta,0.5) * pow(CPM, 2) / 10))
            minCp = minCp > 10 ? minCp : 10
            maxCp = (baseAtt + 15) * pow((baseDef + 15),0.5) * pow((baseSta + 15),0.5) * pow(CPM, 2) / 10
            maxCp = Double(lround(maxCp))
            maxCp = maxCp > 10 ? maxCp : 10
            cp = min(max(cp, Double(minCp)), Double(maxCp))
        }
    }
    
    init(number:String, name:String, baseAtt:Double, baseDef:Double, baseSta:Double){
        self.number = number
        self.name = name
        self.baseAtt = baseAtt
        self.baseDef = baseDef
        self.baseSta = baseSta
        self.indiAtt = 0
        self.indiDef = 0
        self.indiSta = 0
        
        self.CPM = 0.0
        self.stardust = 0.0
        self.candy = 0.0
        self.minCp = 0.0
        self.maxCp = 0.0
        self.cp = 0.0
        self.minHp = 0.0
        self.maxHp = 0.0
        self.hp = 0.0
        self.level = 20.0
    }
    
    mutating func calculateIndiValue() {
        let CPM = self.CPM
        let baseAtt = self.baseAtt
        let baseDef = self.baseDef
        let baseSta = self.baseSta
        
        // 1. calculate indi sta
        var staRange = [Int]()
        for sta in (0...15) {
            let hp = Double(lround((baseSta + Double(sta)) * CPM))
            if hp == self.hp {
                staRange.append(sta)
            }
        }
        self.indiSta = staRange.contains(0) ? 0 : Double(staRange.maxElement()!)
        
        // 2. calculate indi att + def
        let indiSta = self.indiSta
        var adValue = 0
        var closeValue = 10000.0
        for ad in (0...30) {
            let att = Double(ad) / 2
            let def = Double(ad) / 2
            let cp = Double(lround((baseAtt + att) * pow((baseDef + def),0.5) * pow((baseSta + indiSta),0.5) * pow(CPM, 2) / 10))
            if abs(cp - self.cp) < closeValue {
                closeValue = abs(cp - self.cp)
                adValue = ad
            }
        }
        self.indiAtt = Double(adValue) / 2
        self.indiDef = Double(adValue) / 2
    }
}

let pokemonData:[Pokemon] = [
    Pokemon(number: "#001", name: "種子", baseAtt: 126, baseDef: 126, baseSta: 90),
    Pokemon(number: "#001", name: "種子2", baseAtt: 126, baseDef: 126, baseSta: 90),
    Pokemon(number: "#002", name: "種子3", baseAtt: 156, baseDef: 158, baseSta: 120),
    Pokemon(number: "#003", name: "種子4", baseAtt: 198, baseDef: 200, baseSta: 160),
    Pokemon(number: "#004", name: "種子5", baseAtt: 128, baseDef: 108, baseSta: 78),
    Pokemon(number: "#005", name: "種子6", baseAtt: 160, baseDef: 140, baseSta: 116),
    Pokemon(number: "#006", name: "種子7", baseAtt: 212, baseDef: 182, baseSta: 156)
]