class_name DynamicAttribute
extends RefCounted

var origin := 0.0
var current := 0.0

enum EffectType {
	BASIC,
	MULTI,
	FINAL,
}

var basic_map: Dictionary[StringName, Effect] = {}
var multi_map: Dictionary[StringName, Effect] = {}
var final_map: Dictionary[StringName, Effect] = {}

func get_effect_map(t: EffectType) -> Dictionary[StringName, Effect]:
	match t:
		EffectType.BASIC:
			return basic_map
		EffectType.MULTI:
			return multi_map
		EffectType.FINAL:
			return final_map
		_:
			return {}

func refresh_value():
	current = origin
	for effect: Effect in basic_map.values():
		for i in range(effect.stack):
			current += effect.value
	
	var coefficient := 1.0
	for effect: Effect in multi_map.values():
		for i in range(effect.stack):
			coefficient += effect.value
	current *= coefficient

	for effect: Effect in final_map.values():
		for i in range(effect.stack):
			current *= effect.value

## 加入效果 调用后需要手动刷新
func put_effect(t: EffectType, e: Effect):
	var emap := get_effect_map(t)
	if emap.has(e.effect_name):
		var effect: Effect = emap.get(e.effect_name)
		effect.refresh_and_stack()
	else:
		emap.set(e.effect_name, e)
		e.start_time()

func process_time(delta: float):
	var changed := false
	for map in [basic_map, multi_map, final_map]:
		for key in map.keys():
			var effect: Effect = map.get(key)
			if effect.is_duration():
				var is_expired := effect.process_time_and_expired(delta)
				changed = changed or is_expired
				if is_expired:
					map.erase(key)
	
	if changed:
		refresh_value()
