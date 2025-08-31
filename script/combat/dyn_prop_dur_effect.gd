## 持久效果
class_name DynPropDurEffect
extends RefCounted

enum Type {
	# 若想修改最大值的同时修改当前值，同时赋予持久和瞬时效果即可
	# 因为最大值的修改仅限于基础值，与其他效果互不影响，因此修改的值是绝对的

	## 修改最大值
	MAX_VAL,
	## 百分比修改最大值
	MAX_PER,
	## 修改最小值
	MIN_VAL,

	## 持续修改当前值
	CUR_VAL,
	## 持续百分比地增加当前值
	CUR_PER,
	## 持续根据最大值的百分比修改当前值
	CUR_MAX_PER,

	## 根据当前值与给定值的差逐渐逼近 倍率固定0.01 通过频率和堆叠修改速度
	CUR_TAR_DELTA_001,
}

var effect: DurationEffect
var type: Type

static func new_effect(t: Type, e: DurationEffect) -> DynPropDurEffect:
	var pe := DynPropDurEffect.new()
	pe.type = t
	pe.effect = e
	return pe

# 赋予效果 仅属性类调用
func put_effect_proxy(prop: DynamicProperty):
	match type:
		Type.MAX_VAL:
			prop.put_max_attr_effect(DynAttrEffect.new_effect(DynAttrEffect.Type.BASIC_ADD, effect))
		Type.MAX_PER:
			prop.put_max_attr_effect(DynAttrEffect.new_effect(DynAttrEffect.Type.BASIC_PERCENT, effect))
		Type.MIN_VAL:
			prop.put_min_attr_effect(DynAttrEffect.new_effect(DynAttrEffect.Type.BASIC_ADD, effect))
		_:
			prop.put_prop_effect_proxy(self)

# 生效效果 仅属性类调用
func do_effect_alter_proxy(prop: DynamicProperty, periods: int):
	var e := DynPropInstEffect.new()
	e.effect = Effect.new_instant(effect.from_name, effect.effect_name, effect.value * effect.stack * periods)
	match type:
		Type.CUR_VAL:
			e.type = DynPropInstEffect.Type.CUR_VAL
		Type.CUR_PER:
			e.type = DynPropInstEffect.Type.CUR_PER
		Type.CUR_MAX_PER:
			e.type = DynPropInstEffect.Type.CUR_MAX_PER
		Type.CUR_TAR_DELTA_001:
			e.type = DynPropInstEffect.Type.CUR_VAL
			e.effect.set_value((effect.value - prop.get_current_value()) * 0.01 * effect.stack * periods)
		_:
			return
	e.do_effect_alter_proxy(prop)
