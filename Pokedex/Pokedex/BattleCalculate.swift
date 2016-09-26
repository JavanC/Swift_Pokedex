//
//  BattleCalculate.swift
//  Poke Booklet
//
//  Created by Javan.Chen on 2016/9/23.
//  Copyright © 2016年 Javan. All rights reserved.
//

import UIKit

struct BattleDetail {
    let opponent: Pokemon
    let fastDamage: Int
    let chargeDamage: Int
    
    var hp: Int
    var fastTime: Int
    var chargeTime: Int
    var battleTime: Double
    var triggerTime: Double
    var totalDamage: Int
    var energy: Double
    var percent: Int

    init(opponent: Pokemon, hp: Int, fastDamage: Int, chargeDamage: Int) {
        self.opponent = opponent
        self.hp = hp
        self.fastDamage = fastDamage
        self.chargeDamage = chargeDamage
        self.fastTime = 0
        self.chargeTime = 0
        self.battleTime = 0.0
        self.triggerTime = 0.0
        self.totalDamage = 0
        self.energy = 0.0
        self.percent = 0
    }
}

func damageCalculate(attack: Attack, attackPokemon: Pokemon, defendPokemon: Pokemon) -> Int {
    let atk = (attackPokemon.baseAtt + attackPokemon.indiAtk) * attackPokemon.CPM
    let def = (defendPokemon.baseDef + defendPokemon.indiDef) * defendPokemon.CPM
    let STAB = attackPokemon.type.contains(attack.type) ? 1.25 : 1
    let effec = effectiveness(attack.type, pokemonTypes: defendPokemon.type)
    let damage = Int(0.5 * attack.damage * STAB * effec * atk / def) + 1
    return damage
}

func battle(attacker: Pokemon, defender: Pokemon, stopTrigger: Int) -> BattleDetail {
    let A_fasrAttack = attacker.fastAttacks[attacker.fastAttackNumber]
    let A_chargeAttack = attacker.chargeAttacks[attacker.chargeAttackNumber]
    let A_fastDamage = damageCalculate(A_fasrAttack, attackPokemon: attacker, defendPokemon: defender)
    let A_chargeDamage = damageCalculate(A_chargeAttack, attackPokemon: attacker, defendPokemon: defender)
    let A_useCharge = Double(A_chargeDamage) / (A_chargeAttack.duration + 0.5) > Double(A_fastDamage) / A_fasrAttack.duration
    var A_battleDetail = BattleDetail(opponent: defender, hp: attacker.hp, fastDamage: A_fastDamage, chargeDamage: A_chargeDamage)
    
    let D_fasrAttack = defender.fastAttacks[defender.fastAttackNumber]
    let D_chargeAttack = defender.chargeAttacks[defender.chargeAttackNumber]
    let D_fastDamage = damageCalculate(D_fasrAttack, attackPokemon: defender, defendPokemon: attacker)
    let D_chargeDamage = damageCalculate(D_chargeAttack, attackPokemon: defender, defendPokemon: attacker)
    var D_battleDetail = BattleDetail(opponent: attacker, hp: defender.hp * 2, fastDamage: D_fastDamage, chargeDamage: D_chargeDamage)
    
    while true {
        // attacker
        if A_battleDetail.battleTime >= A_battleDetail.triggerTime {
            if A_battleDetail.energy < A_chargeAttack.energy {
                // use fast attack
                A_battleDetail.fastTime += 1
                // set next trigger time
                A_battleDetail.triggerTime += A_fasrAttack.duration
                // calculate damage
                A_battleDetail.totalDamage += A_fastDamage
                D_battleDetail.hp -= A_fastDamage
                // calculate energy
                A_battleDetail.energy += A_fasrAttack.energy
                A_battleDetail.energy = min(A_battleDetail.energy, A_useCharge ? 100 : -100)
                D_battleDetail.energy += Double(Int(Double(A_fastDamage) / 2))
                D_battleDetail.energy = min(D_battleDetail.energy, 200)
            } else {
                // use charge attack
                A_battleDetail.chargeTime += 1
                // set next trigger time
                A_battleDetail.triggerTime += A_chargeAttack.duration + 0.5
                // calculate damage
                A_battleDetail.totalDamage += A_chargeDamage
                D_battleDetail.hp -= A_chargeDamage
                // calculate energy
                A_battleDetail.energy -= A_chargeAttack.energy
                D_battleDetail.energy += Double(Int(Double(A_chargeDamage) / 2))
                D_battleDetail.energy = min(D_battleDetail.energy, 200)
            }
        }
        // defender
        if D_battleDetail.battleTime >= D_battleDetail.triggerTime {
            if D_battleDetail.energy < D_chargeAttack.energy {
                // use fast attack
                D_battleDetail.fastTime += 1
                // set next trigger time
                D_battleDetail.triggerTime += D_fasrAttack.duration + 2.0
                // calculate damage
                D_battleDetail.totalDamage += D_fastDamage
                A_battleDetail.hp -= D_fastDamage
                // calculate energy
                D_battleDetail.energy += D_fasrAttack.energy
                D_battleDetail.energy = min(D_battleDetail.energy, 200)
                A_battleDetail.energy += Double(Int(Double(D_fastDamage) / 2))
                A_battleDetail.energy = min(A_battleDetail.energy, A_useCharge ? 100 : -100)
            } else {
                // use charge attack
                D_battleDetail.chargeTime += 1
                // set next trigger time
                D_battleDetail.triggerTime += D_chargeAttack.duration + 2.0
                // calculate damage
                D_battleDetail.totalDamage += D_chargeDamage
                A_battleDetail.hp -= D_chargeDamage
                // calculate energy
                D_battleDetail.energy -= D_chargeAttack.energy
                A_battleDetail.energy += Double(Int(Double(D_chargeDamage) / 2))
                A_battleDetail.energy = min(A_battleDetail.energy, A_useCharge ? 100 : -100)
            }
        }
        // stop trigger
        if stopTrigger == 1 {
            if A_battleDetail.hp <= 0 {
                A_battleDetail.percent = Int(Double(A_battleDetail.totalDamage) / Double(defender.hp * 2) * 100 )
                return A_battleDetail
            }
        } else {
            if D_battleDetail.hp <= 0 {
                D_battleDetail.percent = Int(Double(D_battleDetail.totalDamage) / Double(attacker.hp) * 100 )
                return D_battleDetail
            }
        }
        // update time
        A_battleDetail.battleTime += 0.01
        D_battleDetail.battleTime += 0.01
    }
}
