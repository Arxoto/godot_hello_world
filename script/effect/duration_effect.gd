## 持续存在型效果
class_name DurationEffect
extends Effect

## 存在计时（仅非瞬发生效）
var life_time := 0.0
## 持续时间 零和负数表示无限存在
var duration_ms := 0
## 生效周期 零和负数表示不重复生效
var period_ms := 0

## 堆叠层数 重新添加效果时触发
var stack := 1
## 堆叠上限 不支持无上限
var max_stack := 1

#region newer

## 【立即生效】型效果
static func new_instant(from_name_v: StringName, effect_name_v: StringName, v: float) -> Effect:
	var e := Effect.new()
	e.from_name = from_name_v
	e.effect_name = effect_name_v
	e.value = v
	return e

## 【持续存在】型效果 [br]
## [duration_time_ms] 持续时间 零和负数表示无限存在 [br]
## [period_time_ms] 生效周期 零和负数表示不重复生效 [br]
static func new_duration(from_name_v: StringName, effect_name_v: StringName, v: float, duration_time_ms := 0, period_time_ms := 0) -> DurationEffect:
	var de := DurationEffect.new()
	de.from_name = from_name_v
	de.effect_name = effect_name_v
	de.value = v
	de.duration_ms = duration_time_ms
	de.period_ms = period_time_ms
	return de

#endregion

#region func

## 是否无限存在
func is_infinite() -> bool:
	return duration_ms <= 0

## 是否持续一段时间
func is_duration() -> bool:
	return duration_ms > 0

## 是否周期生效
func is_period() -> bool:
	return period_ms > 0

## 重新开始计时
func restart_life():
	life_time = 0.0

## 是否过期
func is_expired() -> bool:
	if not is_duration():
		return false
	return (life_time * 1000 as int) >= duration_ms

## 处理时间 返回周期生效次数
func process_period(delta: float) -> int:
	if is_expired():
		return 0
	
	if not is_period():
		life_time += delta
		return 0
	
	var old_count: int = (life_time * 1000 as int) % period_ms
	life_time += delta
	var new_count: int = (life_time * 1000 as int) % period_ms
	if is_expired():
		return duration_ms % period_ms
	else:
		return new_count - old_count

## 设置堆叠上限
func limit_max_stack(v: int) -> DurationEffect:
	max_stack = v
	return self

## 尝试叠加 返回叠加后的层数
func add_stack(c: int) -> int:
	stack = min(max_stack, stack + c)
	return stack

## 刷新并堆叠 返回叠加后的层数
func refresh_and_add_stack(de: DurationEffect) -> int:
	self.from_name = de.from_name
	self.value = de.value
	restart_life()
	return add_stack(de.stack)

#endregion
