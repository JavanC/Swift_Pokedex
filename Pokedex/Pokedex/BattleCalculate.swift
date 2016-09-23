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

func battle2(attacker: Pokemon, defender: Pokemon, stopTrigger: Int) {
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
    var D_battleDetail = BattleDetail(opponent: attacker, hp: defender.hp, fastDamage: D_fastDamage, chargeDamage: D_chargeDamage)
    
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
                A_battleDetail.energy = min(A_battleDetail.energy, A_useCharge ? 100 : 0)
                D_battleDetail.energy += Double(Int(Double(A_fastDamage) / 2))
                D_battleDetail.energy = min(D_battleDetail.energy, 200)
            } else {
                // use charge attack
                A_battleDetail.chargeTime += 1
                // set next trigger time
                A_battleDetail.triggerTime += A_chargeAttack.duration
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
            if D_battleDetail.energy < D_battleDetail.energy {
                // use fast attack
                D_battleDetail.fastTime += 1
                // set next trigger time
                D_battleDetail.triggerTime += D_fasrAttack.duration
                // calculate damage
                D_battleDetail.totalDamage += D_fastDamage
                A_battleDetail.hp -= A_fastDamage
                // calculate energy
                D_battleDetail.energy += D_fasrAttack.energy
                D_battleDetail.energy = min(D_battleDetail.energy, 200)
                A_battleDetail.energy += Double(Int(Double(D_fastDamage) / 2))
                A_battleDetail.energy = min(A_battleDetail.energy, 100)
            } else {
                // use charge attack
                D_battleDetail.chargeTime += 1
                // set next trigger time
                D_battleDetail.triggerTime += D_chargeAttack.duration
                // calculate damage
                D_battleDetail.totalDamage += D_chargeDamage
                A_battleDetail.hp -= D_chargeDamage
                // calculate energy
                D_battleDetail.energy -= D_chargeAttack.energy
                A_battleDetail.energy += Double(Int(Double(A_chargeDamage) / 2))
                A_battleDetail.energy = min(D_battleDetail.energy, 100)
            }
        }
        // update time
        A_battleDetail.battleTime += 0.01
        D_battleDetail.battleTime += 0.01
    }
}

func battle(myPokemon: Pokemon, opponent: Pokemon, isAttacker: Bool) -> BattleDetail {
    let time = battleTime(myPokemon, opponent: opponent, isAttacker: isAttacker)
    let fastAttack = myPokemon.fastAttacks[myPokemon.fastAttackNumber]
    let chargeAttack = myPokemon.chargeAttacks[myPokemon.chargeAttackNumber]
    let atk = (myPokemon.baseAtt + myPokemon.indiAtk) * myPokemon.CPM
    let def = (opponent.baseDef + opponent.indiDef) * opponent.CPM
    let fastSTAB = myPokemon.type.contains(fastAttack.type) ? 1.25 : 1
    let fastEffec = effectiveness(fastAttack.type, pokemonTypes: opponent.type)
    let fastDamage = Int(0.5 * fastAttack.damage * fastSTAB * fastEffec * atk / def) + 1
    let chargeSTAB = myPokemon.type.contains(chargeAttack.type) ? 1.25 : 1
    let chargeEffec = effectiveness(chargeAttack.type, pokemonTypes: opponent.type)
    let chargeDamage = Int(0.5 * chargeAttack.damage * chargeSTAB * chargeEffec * atk / def) + 1
    let useCharge = !isAttacker || Double(chargeDamage) / (chargeAttack.duration + 0.5) > Double(fastDamage) / fastAttack.duration
    var damage = 0
    var fastTime = 0
    var chargeTime = 0
    var second = 0.0
    var energy = 0.0
    while(true) {
        if energy < chargeAttack.energy {
            second += fastAttack.duration + (isAttacker ? 0 : 2.0)
            if second > time { break }
            damage += fastDamage
            energy += fastAttack.energy
            energy = min(energy, 100)
            energy = useCharge ? energy : 0
            fastTime += 1
        } else {
            second += chargeAttack.duration + (isAttacker ? 0.5 : 2.0)
            if second > time { break }
            damage += chargeDamage
            energy -= chargeAttack.energy
            chargeTime += 1
        }
    }
    let opponentHP = Double(opponent.hp) * (isAttacker ? 2 : 1)
    let percent = Int(Double(damage) / opponentHP * 100)
    return BattleDetail(opponent: opponent, battleTime: time, fastDamage: fastDamage,chargeDamage: chargeDamage,
                        fastTime: fastTime, chargeTime: chargeTime, totalDamage: damage, percent: percent)
}

func battleTime(myPokemon: Pokemon, opponent: Pokemon, isAttacker: Bool) -> Double {
    var limitTime = 1000.0
    for fastAttack in opponent.fastAttacks {
        for chargeAttack in opponent.chargeAttacks {
            let atk = (opponent.baseAtt + opponent.indiAtk) * opponent.CPM
            let def = (myPokemon.baseDef + myPokemon.indiDef) * myPokemon.CPM
            let fastSTAB = opponent.type.contains(fastAttack.type) ? 1.25 : 1
            let fastEffec = effectiveness(fastAttack.type, pokemonTypes: myPokemon.type)
            let fastDamage = Int(0.5 * fastAttack.damage * fastSTAB * fastEffec * atk / def) + 1
            let chargeSTAB = opponent.type.contains(chargeAttack.type) ? 1.25 : 1
            let chargeEffec = effectiveness(chargeAttack.type, pokemonTypes: myPokemon.type)
            let chargeDamage = Int(0.5 * chargeAttack.damage * chargeSTAB * chargeEffec * atk / def) + 1
            let useCharge = isAttacker || Double(chargeDamage) / (chargeAttack.duration + 0.5) > Double(fastDamage) / fastAttack.duration
            var damage = 0
            var second = 0.0
            var energy = 0.0
            while(true) {
                if energy < chargeAttack.energy {
                    second += fastAttack.duration + (isAttacker ? 2.0 : 0)
                    damage += fastDamage
                    energy += fastAttack.energy
                    energy = min(energy, 100)
                    energy = useCharge ? energy : 0
                } else {
                    second += chargeAttack.duration + (isAttacker ? 2.0 : 0.5)
                    damage += chargeDamage
                    energy -= chargeAttack.energy
                }
                if Double(damage) > Double(myPokemon.hp) * (isAttacker ? 1 : 2) { break }
            }
            limitTime = min(limitTime, second)
        }
    }
    return limitTime
}
