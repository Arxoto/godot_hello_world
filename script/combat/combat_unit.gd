class_name CombatUnit
extends Node

@export var race_data: RaceData = RaceData.new()

var level_up := LevelUp.new()

#region 战时动态值

## 血量 基础值受气力影响
var health: ExProp
#   energy
## 连贯 基础值不受影响 为连续进攻的加成
var stamina: ExProp
## 气势 最大值受信念影响 为战斗优雅程度加成
var magicka: ExProp

## 防护（替身） 后续视系统复杂度增加
var defence: ExProp

#endregion

#region 内禀属性（人物成长）

## 气力 影响：血量（仅初始）&负载（装备效果）&伤害&冲击力
var strength: ExAttr
## 信念 影响：气势（仅初始，可通过符文提升护盾，但护盾无法防御冲击伤害）&伤害
var belief: ExAttr

#endregion

#region 外赋属性（环境装备加成）

## 武器锋利度 影响切割伤害
var weapon_sharpness: ExAttr
## 武器惯性 影响连贯值和冲击伤害
var weapon_inertia: ExAttr
## 盔甲坚硬 影响切割伤害
var armor_hard: ExAttr
## 盔甲柔韧 影响冲击伤害
var armor_soft: ExAttr

#endregion

func _ready():
	init_inner_attrs()
	init_outer_attrs()
	effect_attrs()
	init_props()
	effect_props(owner.name, 0.0)

#region funcs

func init_inner_attrs():
	strength = ExAttr.create(race_data.strength_base + race_data.strength_scale * level_up.strength_points)
	belief = ExAttr.create(race_data.belief_base + race_data.belief_scale * level_up.belief_points)

func init_outer_attrs():
	# todo weapon armor
	return

func effect_attrs():
	# todo add effects inner attrs here
	# refresh inner attrs
	strength.refresh_value()
	belief.refresh_value()
	# todo effects outer attrs
	# refresh outer attrs

func init_props():
	var h = race_data.health_base + race_data.health_scale * strength.get_origin()
	health = ExProp.create_by_max(h)

	var s = race_data.stamina_max
	stamina = ExProp.create(0.0, s, 0.0)

	var m = race_data.magicka_max_base + race_data.magicka_max_scale * belief.get_origin()
	magicka = ExProp.create(race_data.magicka_target_self, m, 0.0)

	defence = ExProp.create_by_max(0.0)

func effect_props(owner_name: StringName, magicka_target_env: float):
	health.put_period_effect(ExPropPeriodEffect.create_inf_max_per(owner_name, EffectNames.HEALTH_RECOVER_RATIO, race_data.health_recover_ratio, race_data.health_recover_period))
	health.put_period_effect(ExPropPeriodEffect.create_inf_val(owner_name, EffectNames.HEALTH_RECOVER_VALUE, race_data.health_recover_value, race_data.health_recover_period))
	health.refresh_period_effect()
	
	var sdv = ExPropPeriodEffect.create_inf_val(owner_name, EffectNames.STAMINA_DECLINE, race_data.stamina_decline_value, race_data.stamina_period)
	sdv.set_wait_time(race_data.stamina_wait)
	stamina.put_period_effect(sdv)
	stamina.refresh_period_effect()

	# todo 目标值
	var mts := ExPropPeriodEffect.create_inf_cur_val_to_val(owner_name, EffectNames.MAGICKA_FLOW_SELF, race_data.magicka_target_self, 10.0, race_data.magicka_target_period)
	magicka.put_period_effect(mts)
	var mte := ExPropPeriodEffect.create_inf_cur_val_to_val(owner_name, EffectNames.MAGICKA_FLOW_ENV, magicka_target_env, 10.0, race_data.magicka_target_period)
	magicka.put_period_effect(mte)
	magicka.refresh_period_effect()

	defence.refresh_period_effect()

#endregion

func _process(delta: float) -> void:
	strength.process_time(delta)
	belief.process_time(delta)

	# todo effects outer attrs

	health.process_time(delta)
	stamina.process_time(delta)
	magicka.process_time(delta)
	defence.process_time(delta)
	
	#if owner.name == "Player":
		#print("player health: %s %s %s " % [health.get_min(), health.get_current(), health.get_max()])
		#print("player health: %s " % [health.get_period_effect_names()])
