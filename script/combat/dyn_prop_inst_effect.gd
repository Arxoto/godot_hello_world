## 瞬时效果
#class_name DynPropInstEffect
extends RefCounted

enum Type {
	## 修改当前值
	CUR_VAL,
	## 百分比地增加当前值
	CUR_PER,
	## 根据最大值百分比地增加当前值
	CUR_MAX_PER,
}

var effect: Effect
var type: Type

static func new_effect(t: Type, e: Effect) -> DynPropInstEffect:
	var pe := DynPropInstEffect.new()
	pe.type = t
	pe.effect = e
	return pe

# 生效效果 仅属性类调用
func do_effect_alter_proxy(prop: DynamicProperty) -> float:
	match type:
		Type.CUR_VAL:
			return prop.alter_current_value_proxy(effect)
		Type.CUR_PER:
			var v := effect.value * prop.get_current_value()
			return prop.alter_current_value_proxy(Effect.new_instant(effect.from_name, effect.effect_name, v))
		Type.CUR_MAX_PER:
			var v := effect.value * prop.get_max_value()
			return prop.alter_current_value_proxy(Effect.new_instant(effect.from_name, effect.effect_name, v))
		_:
			return 0.0
