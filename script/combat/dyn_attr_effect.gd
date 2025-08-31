class_name DynAttrEffect
extends RefCounted

enum Type {
	## 基础加法（描述参考：基础伤害增加xx）
	BASIC_ADD,
	## 最终乘法（描述参考：额外xx倍伤害），指数增长、谨慎使用
	FINAL_MULTI,

	## 基础百分比（描述参考：基础伤害提升xx%），可安全使用
	BASIC_PERCENT,
	## 最终百分比（描述参考：伤害提升xx%），可安全使用
	FINAL_PERCENT,
}

var effect: DurationEffect
var type: Type

#region new

static func new_effect(t: Type, e: DurationEffect) -> DynAttrEffect:
	var ae := DynAttrEffect.new()
	ae.effect = e
	ae.type = t
	return ae

#endregion

#region modifier

class AttributeModifier extends RefCounted:
	var basic_add := 0.0
	var final_multi := 1.0
	var basic_percent := 0.0
	var final_percent := 0.0

	func reduce(ae: DynAttrEffect):
		var de := ae.effect
		match ae.type:
			Type.BASIC_ADD:
				for i in range(de.stack):
					basic_add += de.value
			Type.FINAL_MULTI:
				for i in range(de.stack):
					final_multi *= de.value
			Type.BASIC_PERCENT:
				for i in range(de.stack):
					basic_percent += de.value
			Type.FINAL_PERCENT:
				for i in range(de.stack):
					final_percent += de.value

	func do_effect(v: float) -> float:
		return (v + v * basic_percent + basic_add) * (1.0 + final_percent) * final_multi

#endregion
