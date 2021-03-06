//
//  MovesData.swift
//  Pokedex
//
//  Created by Javan.Chen on 2016/8/24.
//  Copyright © 2016年 Javan. All rights reserved.
//

import Foundation

enum Type: Int{
    case Normal, Fire, Water, Electric, Grass, Ice, Fighting, Poison, Ground, Flying, Psychic, Bug, Rock, Ghost, Dragon, Dark, Steel, Fairy
}

func typeEffectiveness(type: Type) -> [[Type]] {
    switch type {
    case .Normal:
        let resistance = [Type.Ghost, Type.Rock, Type.Steel]
        return [[] , resistance]
    case .Fire:
        let week = [Type.Grass, Type.Ice, Type.Bug, Type.Steel]
        let resistance = [Type.Fire, Type.Water, Type.Rock, Type.Dragon]
        return [week, resistance]
    case .Water:
        let week = [Type.Fire, Type.Ground, Type.Rock]
        let resistance = [Type.Water, Type.Grass, Type.Dragon]
        return [week, resistance]
    case .Electric:
        let week = [Type.Water, Type.Flying]
        let resistance = [Type.Ground, Type.Electric, Type.Grass, Type.Dragon]
        return [week, resistance]
    case .Grass:
        let week = [Type.Water, Type.Ground, Type.Rock]
        let resistance = [Type.Fire, Type.Grass, Type.Poison, Type.Flying, Type.Bug, Type.Dragon, Type.Steel]
        return [week, resistance]
    case .Ice:
        let week = [Type.Grass, Type.Ground, Type.Flying, Type.Dragon]
        let resistance = [Type.Fire, Type.Water, Type.Ice, Type.Steel]
        return [week, resistance]
    case .Fighting:
        let week = [Type.Normal, Type.Ice, Type.Rock, Type.Dark, Type.Steel]
        let resistance = [Type.Ghost, Type.Poison, Type.Flying, Type.Psychic, Type.Bug, Type.Fairy]
        return [week, resistance]
    case .Poison:
        let week = [Type.Grass, Type.Fairy]
        let resistance = [Type.Steel, Type.Poison, Type.Ground, Type.Rock, Type.Ghost]
        return [week, resistance]
    case .Ground:
        let week = [Type.Fire, Type.Electric, Type.Poison, Type.Rock, Type.Steel]
        let resistance = [Type.Flying, Type.Grass, Type.Bug]
        return [week, resistance]
    case .Flying:
        let week = [Type.Grass, Type.Fighting, Type.Bug]
        let resistance = [Type.Electric, Type.Rock, Type.Steel]
        return [week, resistance]
    case .Psychic:
        let week = [Type.Fighting, Type.Poison]
        let resistance = [Type.Dark, Type.Psychic, Type.Steel]
        return [week, resistance]
    case .Bug:
        let week = [Type.Grass, Type.Psychic, Type.Dark]
        let resistance = [Type.Fire, Type.Fighting, Type.Poison, Type.Flying, Type.Ghost, Type.Steel, Type.Fairy]
        return [week, resistance]
    case .Rock:
        let week = [Type.Fire, Type.Ice, Type.Flying, Type.Bug]
        let resistance = [Type.Fighting, Type.Ground, Type.Steel]
        return [week, resistance]
    case .Ghost:
        let week = [Type.Psychic, Type.Ghost]
        let resistance = [Type.Normal, Type.Dark]
        return [week, resistance]
    case .Dragon:
        let week = [Type.Dragon]
        let resistance = [Type.Fairy, Type.Steel]
        return [week, resistance]
    case .Dark:
        let week = [Type.Psychic, Type.Ghost]
        let resistance = [Type.Fighting, Type.Dark, Type.Fairy]
        return [week, resistance]
    case .Steel:
        let week = [Type.Ice, Type.Rock, Type.Fairy]
        let resistance = [Type.Fire, Type.Water, Type.Electric, Type.Steel]
        return [week, resistance]
    case .Fairy:
        let week = [Type.Fighting, Type.Dragon, Type.Dark]
        let resistance = [Type.Fire, Type.Poison, Type.Steel]
        return [week, resistance]
    }
}

func effectiveness(attackType: Type, pokemonTypes: [Type]) -> Double {
    var effec = 1.0
    for pokemonType in pokemonTypes {
        if typeEffectiveness(attackType)[0].contains(pokemonType) { effec *= 1.25 }
        if typeEffectiveness(attackType)[1].contains(pokemonType) { effec *= 0.8 }
    }
    return effec
}

struct Attack {
    let name: String
    let type: Type
    let damage: Double
    let duration: Double
    let energy: Double
}

let FastAttacks: [String: Attack] = [
    "Acid"          : Attack(name: "Acid", type: .Poison, damage: 10, duration: 1.05, energy: 10),
    "Bite"          : Attack(name: "Bite", type: .Dark, damage: 6, duration: 0.5, energy: 7),
    "Bubble"        : Attack(name: "Bubble", type: .Water, damage: 25, duration: 2.3, energy: 25),
    "Bug Bite"      : Attack(name: "Bug Bite", type: .Bug, damage: 5, duration: 0.45, energy: 7),
    "Bullet Punch"  : Attack(name: "Bullet Punch", type: .Steel, damage: 10, duration: 1.2, energy: 10),
    "Confusion"     : Attack(name: "Confusion", type: .Psychic, damage: 15, duration: 1.51, energy: 14),
    "Cut"           : Attack(name: "Cut", type: .Normal, damage: 12, duration: 1.13, energy: 10),
    "Dragon Breath" : Attack(name: "Dragon Breath", type: .Dragon, damage: 6, duration: 0.5, energy: 7),
    "Ember"         : Attack(name: "Ember", type: .Fire, damage: 10, duration: 1.05, energy: 10),
    "Feint Attack"  : Attack(name: "Feint Attack", type: .Dark, damage: 12, duration: 1.04, energy: 10),
    "Fire Fang"     : Attack(name: "Fire Fang", type: .Fire, damage: 10, duration: 0.84, energy: 8),
    "Frost Breath"  : Attack(name: "Frost Breath", type: .Ice, damage: 9, duration: 0.81, energy: 7),
    "Fury Cutter"   : Attack(name: "Fury Cutter", type: .Bug, damage: 3, duration: 0.4, energy: 6),
    "Ice Shard"     : Attack(name: "Ice Shard", type: .Ice, damage: 15, duration: 1.4, energy: 12),
    "Karate Chop"   : Attack(name: "Karate Chop", type: .Fighting, damage: 6, duration: 0.8, energy: 8),
    "Lick"          : Attack(name: "Lick", type: .Ghost, damage: 5, duration: 0.5, energy: 6),
    "Low Kick"      : Attack(name: "Low Kick", type: .Fighting, damage: 5, duration: 0.6, energy: 7),
    "Metal Claw"    : Attack(name: "Metal Claw", type: .Steel, damage: 8, duration: 0.63, energy: 7),
    "Mud Shot"      : Attack(name: "Mud Shot", type: .Ground, damage: 6, duration: 0.55, energy: 7),
    "Mud Slap"      : Attack(name: "Mud Slap", type: .Ground, damage: 15, duration: 1.35, energy: 12),
    "Peck"          : Attack(name: "Peck", type: .Flying, damage: 10, duration: 1.15, energy: 10),
    "Poison Jab"    : Attack(name: "Poison Jab", type: .Poison, damage: 12, duration: 1.05, energy: 10),
    "Poison Sting"  : Attack(name: "Poison Sting", type: .Poison, damage: 6, duration: 0.575, energy: 8),
    "Pound"         : Attack(name: "Pound", type: .Normal, damage: 7, duration: 0.54, energy: 7),
    "Psycho Cut"    : Attack(name: "Psycho Cut", type: .Psychic, damage: 7, duration: 0.57, energy: 7),
    "Quick Attack"  : Attack(name: "Quick Attack", type: .Normal, damage: 10, duration: 1.33, energy: 12),
    "Razor Leaf"    : Attack(name: "Razor Leaf", type: .Grass, damage: 15, duration: 1.45, energy: 12),
    "Rock Smash"    : Attack(name: "Rock Smash", type: .Fighting, damage: 15, duration: 1.41, energy: 12),
    "Rock Throw"    : Attack(name: "Rock Throw", type: .Rock, damage: 12, duration: 1.36, energy: 15),
    "Scratch"       : Attack(name: "Scratch", type: .Normal, damage: 6, duration: 0.5, energy: 7),
    "Shadow Claw"   : Attack(name: "Shadow Claw", type: .Ghost, damage: 11, duration: 0.95, energy: 8),
    "Spark"         : Attack(name: "Spark", type: .Electric, damage: 7, duration: 0.7, energy: 8),
    "Splash"        : Attack(name: "Splash", type: .Water, damage: 0, duration: 1.23, energy: 0),
    "Steel Wing"    : Attack(name: "NamSteel Winge", type: .Steel, damage: 15, duration: 1.33, energy: 12),
    "Sucker Punch"  : Attack(name: "Sucker Punch", type: .Dark, damage: 7, duration: 0.7, energy: 9),
    "Tackle"        : Attack(name: "Tackle", type: .Normal, damage: 12, duration: 1.1, energy: 10),
    "Thunder Shock" : Attack(name: "Thunder Shock", type: .Electric, damage: 5, duration: 0.6, energy: 8),
    "Vine Whip"     : Attack(name: "Vine Whip", type: .Grass, damage: 7, duration: 0.65, energy: 7),
    "Water Gun"     : Attack(name: "Water Gun", type: .Water, damage: 6, duration: 0.5, energy: 7),
    "Wing Attack"   : Attack(name: "Wing Attack", type: .Flying, damage: 9, duration: 0.75, energy: 7),
    "Zen Headbutt"  : Attack(name: "Zen Headbutt", type: .Psychic, damage: 12, duration: 1.05, energy: 9),
]

let ChargeAttacks: [String: Attack] = [
    "Aerial Ace"    : Attack(name: "Aerial Ace", type: .Flying, damage: 30, duration: 2.9, energy: 25),
    "Air Cutter"    : Attack(name: "Air Cutter", type: .Flying, damage: 30, duration: 3.3, energy: 25),
    "Ancient Power" : Attack(name: "Ancient Power", type: .Rock, damage: 35, duration: 3.6, energy: 25),
    "Aqua Jet"      : Attack(name: "Aqua Jet", type: .Water, damage: 25, duration: 2.35, energy: 20),
    "Aqua Tail"     : Attack(name: "Aqua Tail", type: .Water, damage: 45, duration: 2.35, energy: 50),
    "Blizzard"      : Attack(name: "Blizzard", type: .Ice, damage: 100, duration: 3.9, energy: 100),
    "Body Slam"     : Attack(name: "Body Slam", type: .Normal, damage: 40, duration: 1.56, energy: 50),
    "Bone Club"     : Attack(name: "Bone Club", type: .Ground, damage: 25, duration: 1.6, energy: 25),
    "Brick Break"   : Attack(name: "Brick Break", type: .Fighting, damage: 30, duration: 1.6, energy: 33),
    "Brine"         : Attack(name: "Brine", type: .Water, damage: 25, duration: 2.4, energy: 25),
    "Bubble Beam"   : Attack(name: "Bubble Beam", type: .Water, damage: 30, duration: 2.9, energy: 25),
    "Bug Buzz"      : Attack(name: "Bug Buzz", type: .Bug, damage: 75, duration: 4.25, energy: 50),
    "Bulldoze"      : Attack(name: "Bulldoze", type: .Ground, damage: 35, duration: 3.4, energy: 25),
    "Cross Chop"    : Attack(name: "Cross Chop", type: .Fighting, damage: 60, duration: 2, energy: 100),
    "Cross Poison"  : Attack(name: "Cross Poison", type: .Poison, damage: 25, duration: 1.5, energy: 25),
    "Dark Pulse"    : Attack(name: "Dark Pulse", type: .Dark, damage: 45, duration: 3.5, energy: 33),
    "Dazzling Gleam": Attack(name: "Dazzling Gleam", type: .Fairy, damage: 55, duration: 4.2, energy: 33),
    "Dig"           : Attack(name: "Dig", type: .Ground, damage: 70, duration: 5.8, energy: 33),
    "Disarming Voice"   : Attack(name: "Disarming Voice", type: .Fairy, damage: 25, duration: 3.9, energy: 20),
    "Discharge"     : Attack(name: "Discharge", type: .Electric, damage: 35, duration: 2.5, energy: 33),
    "Dragon Claw"   : Attack(name: "Dragon Claw", type: .Dragon, damage: 35, duration: 1.6, energy: 50),
    "Dragon Pulse"  : Attack(name: "Dragon Pulse", type: .Dragon, damage: 65, duration: 3.6, energy: 50),
    "Draining Kiss" : Attack(name: "Draining Kiss", type: .Fairy, damage: 25, duration: 2.8, energy: 20),
    "Drill Peck"    : Attack(name: "Drill Peck", type: .Flying, damage: 40, duration: 2.7, energy: 33),
    "Drill Run"     : Attack(name: "Drill Run", type: .Ground, damage: 50, duration: 3.4, energy: 33),
    "Earthquake"    : Attack(name: "Earthquake", type: .Ground, damage: 100, duration: 4.2, energy: 100),
    "Fire Blast"    : Attack(name: "Fire Blast", type: .Fire, damage: 100, duration: 4.1, energy: 100),
    "Fire Punch"    : Attack(name: "Fire Punch", type: .Fire, damage: 40, duration: 2.8, energy: 33),
    "Flame Burst"   : Attack(name: "Flame Burst", type: .Fire, damage: 30, duration: 2.1, energy: 25),
    "Flame Charge"  : Attack(name: "Flame Charge", type: .Fire, damage: 25, duration: 3.1, energy: 20),
    "Flame Wheel"   : Attack(name: "Flame Wheel", type: .Fire, damage: 40, duration: 4.6, energy: 25),
    "Flamethrower"  : Attack(name: "Flamethrower", type: .Fire, damage: 55, duration: 2.9, energy: 50),
    "Flash Cannon"  : Attack(name: "Flash Cannon", type: .Steel, damage: 60, duration: 3.9, energy: 33),
    "Gunk Shot"     : Attack(name: "Gunk Shot", type: .Poison, damage: 65, duration: 3, energy: 100),
    "Heat Wave"     : Attack(name: "Heat Wave", type: .Fire, damage: 80, duration: 3.8, energy: 100),
    "Horn Attack"   : Attack(name: "Horn Attack", type: .Normal, damage: 25, duration: 2.2, energy: 25),
    "Hurricane"     : Attack(name: "Hurricane", type: .Flying, damage: 80, duration: 3.2, energy: 100),
    "Hydro Pump"    : Attack(name: "Hydro Pump", type: .Water, damage: 90, duration: 3.8, energy: 100),
    "Hyper Beam"    : Attack(name: "Hyper Beam", type: .Normal, damage: 120, duration: 5, energy: 100),
    "Hyper Fang"    : Attack(name: "Hyper Fang", type: .Normal, damage: 35, duration: 2.1, energy: 33),
    "Ice Beam"      : Attack(name: "Ice Beam", type: .Ice, damage: 65, duration: 3.65, energy: 50),
    "Ice Punch"     : Attack(name: "Ice Punch", type: .Ice, damage: 45, duration: 3.5, energy: 33),
    "Icy Wind"      : Attack(name: "Icy Wind", type: .Ice, damage: 25, duration: 3.8, energy: 20),
    "Iron Head"     : Attack(name: "Iron Head", type: .Steel, damage: 30, duration: 2, energy: 33),
    "Leaf Blade"    : Attack(name: "Leaf Blade", type: .Grass, damage: 55, duration: 2.8, energy: 50),
    "Low Sweep"     : Attack(name: "Low Sweep", type: .Fighting, damage: 30, duration: 2.25, energy: 25),
    "Magnet Bomb"   : Attack(name: "Magnet Bomb", type: .Steel, damage: 30, duration: 2.8, energy: 25),
    "Megahorn"      : Attack(name: "Megahorn", type: .Bug, damage: 80, duration: 3.2, energy: 100),
    "Moonblast"     : Attack(name: "Moonblast", type: .Fairy, damage: 85, duration: 4.1, energy: 100),
    "Mud Bomb"      : Attack(name: "Mud Bomb", type: .Ground, damage: 30, duration: 2.6, energy: 25),
    "Night Slash"   : Attack(name: "Night Slash", type: .Dark, damage: 30, duration: 2.7, energy: 25),
    "Ominous Wind"  : Attack(name: "Ominous Wind", type: .Ghost, damage: 30, duration: 3.1, energy: 25),
    "Petal Blizzard": Attack(name: "Petal Blizzard", type: .Grass, damage: 65, duration: 3.2, energy: 50),
    "Play Rough"    : Attack(name: "Play Rough", type: .Fairy, damage: 55, duration: 2.9, energy: 50),
    "Poison Fang"   : Attack(name: "Poison Fang", type: .Poison, damage: 25, duration: 2.4, energy: 20),
    "Power Gem"     : Attack(name: "Power Gem", type: .Rock, damage: 40, duration: 2.9, energy: 33),
    "Power Whip"    : Attack(name: "Power Whip", type: .Grass, damage: 70, duration: 2.8, energy: 100),
    "Psybeam"       : Attack(name: "Psybeam", type: .Psychic, damage: 40, duration: 3.8, energy: 25),
    "Psychic"       : Attack(name: "Psychic", type: .Psychic, damage: 55, duration: 2.8, energy: 50),
    "Psyshock"      : Attack(name: "Psyshock", type: .Psychic, damage: 40, duration: 2.7, energy: 33),
    "Rock Slide"    : Attack(name: "Rock Slide", type: .Rock, damage: 50, duration: 3.2, energy: 33),
    "Rock Tomb"     : Attack(name: "Rock Tomb", type: .Rock, damage: 30, duration: 3.4, energy: 25),
    "Scald"         : Attack(name: "Scald", type: .Water, damage: 55, duration: 4, energy: 33),
    "Seed Bomb"     : Attack(name: "Seed Bomb", type: .Grass, damage: 40, duration: 2.4, energy: 33),
    "Shadow Ball"   : Attack(name: "Shadow Ball", type: .Ghost, damage: 45, duration: 3.08, energy: 33),
    "Signal Beam"   : Attack(name: "Signal Beam", type: .Bug, damage: 45, duration: 3.1, energy: 33),
    "Sludge"        : Attack(name: "Sludge", type: .Poison, damage: 30, duration: 2.6, energy: 25),
    "Sludge Bomb"   : Attack(name: "Sludge Bomb", type: Type.Poison, damage: 55, duration: 2.6, energy: 50),
    "Sludge Wave"   : Attack(name: "Sludge Wave", type: .Poison, damage: 70, duration: 3.4, energy: 100),
    "Solar Beam"    : Attack(name: "Solar Beam", type: .Grass, damage: 120, duration: 4.9, energy: 100),
    "Stomp"         : Attack(name: "Stomp", type: .Normal, damage: 30, duration: 2.1, energy: 25),
    "Stone Edge"    : Attack(name: "Stone Edge", type: .Rock, damage: 80, duration: 3.1, energy: 100),
    "Struggle"      : Attack(name: "Struggle", type: .Normal, damage: 15, duration: 1.7, energy: 20),
    "Submission"    : Attack(name: "Submission", type: .Fighting, damage: 30, duration: 2.1, energy: 33),
    "Swift"         : Attack(name: "Swift", type: .Normal, damage: 30, duration: 3, energy: 25),
    "Thunder"       : Attack(name: "Thunder", type: .Electric, damage: 100, duration: 4.3, energy: 100),
    "Thunder Punch" : Attack(name: "Thunder Punch", type: .Electric, damage: 40, duration: 2.4, energy: 33),
    "Thunderbolt"   : Attack(name: "Thunderbolt", type: .Electric, damage: 55, duration: 2.7, energy: 50),
    "Twister"       : Attack(name: "Twister", type: .Dragon, damage: 25, duration: 2.7, energy: 20),
    "Vice Grip"     : Attack(name: "Vice Grip", type: .Normal, damage: 25, duration: 2.1, energy: 20),
    "Water Pulse"   : Attack(name: "Water Pulse", type: .Water, damage: 35, duration: 3.3, energy: 25),
    "Wrap"          : Attack(name: "Wrap", type: .Normal, damage: 25, duration: 4, energy: 20),
    "X-Scissor"     : Attack(name: "X-Scissor", type: .Bug, damage: 35, duration: 2.1, energy: 33),
]
