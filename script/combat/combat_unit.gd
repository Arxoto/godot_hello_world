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

## 气力 影响：血量（仅初始）&负载（装备效果）&伤害&冲击力
var strength := DynamicAttribute.new()
## 信念 影响：气势（仅初始，可通过符文提升护盾，但护盾无法防御冲击伤害）&伤害
var belief := DynamicAttribute.new()

#endregion

#region 外赋属性（环境装备加成）

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
	# todo weapon armor
	return

func effect_attrs():
	# todo effects inner attrs
	strength.refresh_value()
	belief.refresh_value()
	# todo effects outer attrs

func init_props():
	health.init_value(race_data.health_base + race_data.health_scale * strength.get_origin_value())

	stamina.init_value(0.0, race_data.stamina_max)

	magicka.init_value(race_data.magicka_target_self, race_data.magicka_max_base + race_data.magicka_max_scale * belief.get_origin_value())

	defence.init_value(0.0)

func effect_props(owner_name: StringName, magicka_target_env: float):
	var hrr := DurationEffect.new_duration(owner_name, EffectNames.HEALTH_RECOVER_RATIO, race_data.health_recover_ratio).with_period_ms(race_data.health_recover_period_ms)
	health.put_dur_effect(DynPropDurEffect.new_effect(DynPropDurEffect.Type.CUR_MAX_PER, hrr))
	var hrv := DurationEffect.new_duration(owner_name, EffectNames.HEALTH_RECOVER_VALUE, race_data.health_recover_value).with_period_ms(race_data.health_recover_period_ms)
	health.put_dur_effect(DynPropDurEffect.new_effect(DynPropDurEffect.Type.CUR_VAL, hrv))
	health.refresh_value()

	var sdv := DurationEffect.new_duration(owner_name, EffectNames.STAMINA_DECLINE, race_data.stamina_decline_value)
	sdv.with_wait_ms(race_data.stamina_wait_ms).with_period_ms(race_data.stamina_period_ms)
	stamina.put_dur_effect(DynPropDurEffect.new_effect(DynPropDurEffect.Type.CUR_VAL, sdv))
	stamina.refresh_value()

	var mts := DurationEffect.new_duration(owner_name, EffectNames.MAGICKA_FLOW_SELF, race_data.magicka_target_self)
	mts.with_period_ms(race_data.magicka_target_period_ms).with_max_stack(race_data.magicka_target_self_stack).add_stack(race_data.magicka_target_self_stack)
	stamina.put_dur_effect(DynPropDurEffect.new_effect(DynPropDurEffect.Type.CUR_TAR_DELTA_001, mts))
	var mte := DurationEffect.new_duration(owner_name, EffectNames.MAGICKA_FLOW_ENV, magicka_target_env)
	mte.with_period_ms(race_data.magicka_target_period_ms).with_max_stack(race_data.magicka_target_env_stack).add_stack(race_data.magicka_target_env_stack)
	stamina.put_dur_effect(DynPropDurEffect.new_effect(DynPropDurEffect.Type.CUR_TAR_DELTA_001, mte))
	magicka.refresh_value()

	defence.refresh_value()

func process_time(delta: float):
	strength.process_time(delta)
	belief.process_time(delta)

	# todo effects outer attrs

	health.process_time(delta)
	stamina.process_time(delta)
	magicka.process_time(delta)
	defence.process_time(delta)

#endregion
