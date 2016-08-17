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
    let hp:Int
}

let pokemonData:[Pokemon] = [
    Pokemon(number: "#001", name: "種子", hp: 10),
    Pokemon(number: "#002", name: "草", hp: 20),
    Pokemon(number: "#003", name: "花", hp: 30),
    Pokemon(number: "#004", name: "小", hp: 40),
    Pokemon(number: "#005", name: "中", hp: 50),
    Pokemon(number: "#006", name: "大", hp: 60)
]