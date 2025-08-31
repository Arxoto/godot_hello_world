## 效果 仅描述如何生效 不实现具体效果
class_name Effect
extends RefCounted

## 来源
var from_name: StringName
## 名称
var effect_name: StringName
## 值 部分效果的生效不取决于该值 但仍可根据正负判断是否增益
var value: float

## 【立即生效】型效果
static func new_instant(from_name_v: StringName, effect_name_v: StringName, v: float) -> Effect:
	var e := Effect.new()
	e.from_name = from_name_v
	e.effect_name = effect_name_v
	e.value = v
	return e
