class_name AttributeEffect
extends RefCounted

var effect: DurationEffect
var type: Type

enum Type {
	## 基础加法（描述参考：基础伤害增加xx）
	BASIC_ADD,
	## 最终乘法（描述参考：伤害提升xx倍），指数增长、谨慎使用
	FINAL_MULTI,
	## 最终百分比（描述参考：伤害提升xx%），可安全使用
	FINAL_PERCENT,
}

#region new

static func new_basic_add(e: DurationEffect) -> AttributeEffect:
	var ae := AttributeEffect.new()
	ae.effect = e
	ae.type = Type.BASIC_ADD
	return ae

static func new_final_multi(e: DurationEffect) -> AttributeEffect:
	var ae := AttributeEffect.new()
	ae.effect = e
	ae.type = Type.FINAL_MULTI
	return ae

static func new_final_percent(e: DurationEffect) -> AttributeEffect:
	var ae := AttributeEffect.new()
	ae.effect = e
	ae.type = Type.FINAL_PERCENT
	return ae

#endregion

#region modifier

class AttributeModifier extends RefCounted:
	var basic_add := 0.0
	var final_multi := 1.0
	var final_percent := 0.0

	func reduce(ae: AttributeEffect):
		var de := ae.effect
		match ae.type:
			Type.BASIC_ADD:
				for i in range(de.stack):
					basic_add += de.value
			Type.FINAL_MULTI:
				for i in range(de.stack):
					final_multi *= de.value
			Type.FINAL_PERCENT:
				for i in range(de.stack):
					final_percent += de.value
			_:
				pass

	func do_effect(v: float) -> float:
		return (v + basic_add) * final_multi * (1.0 + final_percent)

#endregion
