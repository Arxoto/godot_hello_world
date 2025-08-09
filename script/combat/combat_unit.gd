class_name CombatUnit
extends Node

## 防御-无盾
signal block_no_shield()
## 防御-有盾
signal block_has_shield()

## 完美防御-无盾-招架
signal block_perfect_no_shield()
## 完美防御-有盾-格挡
signal block_perfect_has_shield()

## 弹反-无盾-拼刀
signal block_attack_no_shield()
## 弹反-有盾-盾反
signal block_attack_has_shield()
## 弹反-有盾-盾击
signal block_attack_huge_shield()

## 完美闪避
signal dodge_perfect()

## 受击 struck
signal hit()
