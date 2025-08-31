## 动态属性（能力值） 兼容buff系统（不支持瞬时效果）
class_name DynamicAttribute
extends RefCounted

var origin := 0.0
var current := 0.0

## 存储该属性的效果
var effect_map: Dictionary[StringName, DynAttrEffect] = {}

func init_value(v: float):
	origin = v
	current = v

func get_origin_value() -> float:
	return origin

func get_current_value() -> float:
	return current

func refresh_value():
	var am := DynAttrEffect.AttributeModifier.new()
	for ae: DynAttrEffect in effect_map.values():
		am.reduce(ae)
	current = am.do_effect(origin)

## 加入持续效果 调用后需要手动刷新属性值
func put_effect(ae: DynAttrEffect):
	var effect_name := ae.effect.effect_name
	if effect_map.has(effect_name):
		var a_effect: DynAttrEffect = effect_map.get(effect_name)
		a_effect.effect.refresh_and_add_stack(ae.effect)
	else:
		effect_map.set(effect_name, ae)
		ae.effect.restart_life()

func rm_effect(effect_name: StringName):
	effect_map.erase(effect_name)

## 内部自动调用刷新属性值
func process_time(delta: float):
	var changed := false

	for effect_name in effect_map.keys():
		var ae: DynAttrEffect = effect_map.get(effect_name)
		var periods := ae.effect.process_period(delta)

		if periods:
			# 周期性通过堆叠体现
			ae.effect.add_stack(periods)
			changed = true
		
		if ae.effect.is_expired():
			effect_map.erase(effect_name)
			changed = true
	
	if changed:
		refresh_value()
