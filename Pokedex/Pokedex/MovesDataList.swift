//
//  MovesData.swift
//  Pokedex
//
//  Created by Javan.Chen on 2016/8/24.
//  Copyright © 2016年 Javan. All rights reserved.
//

import Foundation

enum Type: Int{
    case NORMAL, FIRE, WATER, ELECTRIC, GRASS, ICE, FIGHTING, POISON, GROUND, FLYING, PSYCHIC, BUG, ROCK, GHOST, DRAGON, 	DARK, STEEL, FAIRY
}

struct Attack {
    let name: String
    let type: Type
    let damage: Double
    let duration: Double
    let energy: Double
}

let FastAttacks: [String: Attack] = [
    "Tackle"    : Attack(name: "Tackle", type: Type.NORMAL, damage: 12, duration: 1.1, energy: 10),
    "Vine Whip" : Attack(name: "Vine Whip", type: Type.GRASS, damage: 7, duration: 0.65, energy: 7)
]

let ChargeAttacks: [String: Attack] = [
    "Power Whip" : Attack(name: "Power Whip", type: Type.GRASS, damage: 70, duration: 2.8, energy: 100),
    "Seed Bomb"  : Attack(name: "Seed Bomb", type: Type.GRASS, damage: 40, duration: 2.4, energy: 33),
    "Sludge Bomb" : Attack(name: "Sludge Bomb", type: Type.POISON, damage: 55, duration: 2.6, energy: 50)
]
