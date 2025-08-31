## 动态属性（血量） 兼容buff系统
class_name DynamicProperty
extends RefCounted

var the_min := DynamicAttribute.new()
var the_max := DynamicAttribute.new()

# 该值是实时改变的 而效果是非幂等的 直接使用基础类型
# 若要实现“对血量的修改幅度增加10%”的效果 可理解为对“效果”生效的效果 需在该类添加独立的效果列表 每次修改时遍历
var current: float

## 存储特殊效果
var effect_map: Dictionary[StringName, DynPropDurEffect] = {}

# max_v 默认使用 v 的值
func init_value(v: float, max_v := v, min_v := 0.0):
	current = v
	the_max.init_value(max_v)
	the_min.init_value(min_v)

func get_current_value() -> float:
	return current

func get_max_value() -> float:
	return the_max.current

func get_min_value() -> float:
	return the_min.current

func fix_current_value():
	current = min(get_current_value(), get_max_value())
	current = max(get_current_value(), get_min_value())

func refresh_value():
	the_max.refresh_value()
	the_min.refresh_value()
	fix_current_value()

## 持久效果 可外部调用 调用后需要手动刷新属性值
func put_dur_effect(pe: DynPropDurEffect):
	pe.put_effect_proxy(self)

## 瞬时效果 返回对当前值的修改值 如造成伤害时处理护盾血量逻辑
func use_inst_effect_alter(pe: DynPropInstEffect) -> float:
	return pe.do_effect_alter_proxy(self)

## 每帧变化
func process_time(delta: float):
	the_max.process_time(delta)
	the_min.process_time(delta)
	fix_current_value()
	
	for effect_name in effect_map.keys():
		var pe: DynPropDurEffect = effect_map.get(effect_name)
		var periods := pe.effect.process_period(delta)

		for i in range(periods):
			pe.do_effect_alter_proxy(self)
		
		if pe.effect.is_expired():
			effect_map.erase(effect_name)
	fix_current_value()

#region effect_proxy

## 赋予最大值效果 仅effect内部调用
func put_max_attr_effect_proxy(ae: DynAttrEffect):
	the_max.put_effect(ae)

## 赋予最小值效果 仅effect内部调用
func put_min_attr_effect_proxy(ae: DynAttrEffect):
	the_min.put_effect(ae)

## 赋予效果 仅effect内部调用
func put_prop_effect_proxy(pe: DynPropDurEffect):
	var effect_name := pe.effect.effect_name
	if effect_map.has(effect_name):
		var p_effect: DynPropDurEffect = effect_map.get(effect_name)
		p_effect.effect.refresh_and_add_stack(pe.effect)
	else:
		effect_map.set(effect_name, pe)
		pe.effect.restart_life()

#endregion

#region alter_current_value

## 如对血量直接造成伤害 return delta 用于处理护盾逻辑
func alter_current_value_proxy(e: Effect) -> float:
	var o := get_current_value()
	current += e.value
	fix_current_value()
	return get_current_value() - o

#endregion
