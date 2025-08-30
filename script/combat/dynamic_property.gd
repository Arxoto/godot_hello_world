## 动态属性（血量） 兼容buff系统
class_name DynamicProperty
extends RefCounted

var the_min := DynamicAttribute.new()
var the_max := DynamicAttribute.new()

# 该值是实时改变的 而效果是非幂等的 直接使用基础类型
# 若要实现“对血量的修改幅度增加10%”的效果 可理解为对“效果”生效的效果 需在该类添加独立的效果列表 每次修改时遍历
var current: float

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

## 每帧变化
func process_time(delta: float):
	the_max.process_time(delta)
	the_min.process_time(delta)
	fix_current_value()

#region effect

## 赋予最大值效果
func use_max_attr_effect(ae: AttributeEffect):
	the_max.use_attr_effect(ae)
	the_max.refresh_value()
	fix_current_value()

## 赋予最小值效果
func use_min_attr_effect(ae: AttributeEffect):
	the_min.use_attr_effect(ae)
	the_min.refresh_value()
	fix_current_value()

## 赋予最大值效果
func use_max_attr_effects(aes: Array[AttributeEffect]):
	for ae in aes:
		the_max.use_attr_effect(ae)
	the_max.refresh_value()
	fix_current_value()

#endregion

#region alter_value

## 影响最大值的同时 影响当前值（同时增加值和上限） todo 实现成 PropertyEffect
func alter_current_and_max_value(e: DurationEffect):
	var o := get_max_value()
	var ae := AttributeEffect.new_basic_add(e)
	use_max_attr_effect(ae)
	var n := get_max_value()

	current += n - o
	fix_current_value()

## 如对血量直接造成伤害 return delta 用于处理护盾逻辑
func alter_current_value(e: Effect) -> float:
	var o := get_current_value()
	current += e.value
	fix_current_value()
	return get_current_value() - o

## 如根据当前血量造成百分比伤害 todo 实现成 PropertyEffect
func alter_current_by_percent(e: Effect):
	current += get_current_value() * e.value
	fix_current_value()

## 如根据最大血量百分比回复 todo 实现成 PropertyEffect
func alter_current_by_max_percent(e: Effect):
	current += get_max_value() * e.value
	fix_current_value()

#endregion
