class_name CombatUnit
extends RefCounted

@export var race_data: RaceData

#region 战时动态值

## 血量 基础值受气力影响
var health := DynamicProperty.new()
## 连贯 基础值不受影响 为连续进攻的加成
var stamina := DynamicProperty.new()
## 气势 最大值受信念影响 为战斗优雅程度加成
var magicka := DynamicProperty.new()

## 防护（替身） 后续视系统复杂度增加
var defence := DynamicProperty.new()

#endregion

#region 内禀属性（人物成长）

## 气力 影响：血量&负载（装备效果）&伤害&冲击力
var strength := DynamicAttribute.new()
## 信念 影响：气势（可通过符文提升护盾，但护盾无法防御冲击伤害）
var belief := DynamicAttribute.new()

#endregion

#region 外赋属性（环境装备加成）

## 气势趋向 todo 引入环境影响效果作用于该属性 todo 趋势影响效果作用于该类
var magicka_target := DynamicAttribute.new()

## 武器锋利度 影响切割伤害
var weapon_sharpness := DynamicAttribute.new()
## 武器惯性 影响连贯值和冲击伤害
var weapon_inertia := DynamicAttribute.new()
## 盔甲坚硬 影响切割伤害
var armor_hard := DynamicAttribute.new()
## 盔甲柔韧 影响冲击伤害
var armor_soft := DynamicAttribute.new()

#endregion

#region funcs

func init_inner_attrs(level_up: LevelUp):
	strength.init_value(race_data.strength_base + race_data.strength_scale * level_up.strength_points)
	belief.init_value(race_data.belief_base + race_data.belief_scale * level_up.belief_points)

func init_outer_attrs():
	magicka_target.init_value(race_data.magicka_target_base)
	# todo weapon armor
	return

# todo effects inner outer attrs

func init_props():
	strength.refresh_value()
	health.init_value(race_data.health_base + race_data.health_scale * strength.get_value())

	stamina.init_value(0.0, race_data.stamina_max)

	belief.refresh_value()
	magicka.init_value(magicka_target.get_value(), race_data.magicka_max_base + race_data.magicka_max_scale * belief.get_value())

	defence.init_value(0.0)

# todo effect props

# todo process

#endregion
