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
    var indiAtt:Int
    var indiDef:Int
    var indiSta:Int
    var level:Double
    var hp:Int
    
    init(number:String, name:String, baseAtt:Double, baseDef:Double, baseSta:Double){
        self.number = number
        self.name = name
        self.baseAtt = baseAtt
        self.baseDef = baseDef
        self.baseSta = baseSta
        self.indiAtt = 0
        self.indiDef = 0
        self.indiSta = 0
        self.level = 1.0
        self.hp = 0
    }
}

let pokemonData:[Pokemon] = [
    Pokemon(number: "#001", name: "種子", baseAtt: 126, baseDef: 126, baseSta: 90),
    Pokemon(number: "#001", name: "種子", baseAtt: 126, baseDef: 126, baseSta: 90),
    Pokemon(number: "#002", name: "種子", baseAtt: 156, baseDef: 158, baseSta: 120),
    Pokemon(number: "#003", name: "種子", baseAtt: 198, baseDef: 200, baseSta: 160),
    Pokemon(number: "#004", name: "種子", baseAtt: 128, baseDef: 108, baseSta: 78),
    Pokemon(number: "#005", name: "種子", baseAtt: 160, baseDef: 140, baseSta: 116),
    Pokemon(number: "#006", name: "種子", baseAtt: 212, baseDef: 182, baseSta: 156)
]