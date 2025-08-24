class_name Effect
extends RefCounted

## 来源
var from_name: StringName
## 名称
var effect_name: StringName
## 效果值
var value: float

## 持续时间 若无表示立即生效 不支持无限存在
var duration_timer: TinyTimer
## 是否持续存在
func is_duration() -> bool:
	return true if duration_timer else false

## 生效周期 单位ms 若负数表示不生效 仅持续存在时生效 生效时增加堆叠层数
var period_ms := -1

## 堆叠层数 可重新添加效果触发 也可周期生效触发
var stack := 1
## 堆叠上限 不支持无上限
var max_stack := 1

func set_stack(v: int):
	stack = min(max_stack, v)

func start_time():
	duration_timer.start_time()

## 处理时间 返回是否过期
func process_time_and_expired(delta: float) -> bool:
	if duration_timer:
		duration_timer.add_time(delta)
		if duration_timer.end():
			return true
	
	if period_ms > 0:
		set_stack((duration_timer.time * 1000 as int) % period_ms)

	return false

## 刷新并堆叠
func refresh_and_stack():
	duration_timer.start_time()
	set_stack(stack + 1)

#region new_func

## 【立即生效】型效果
func new_instant(from_name_v: StringName, effect_name_v: StringName, v: float) -> Effect:
	var e := Effect.new()
	e.from_name = from_name_v
	e.effect_name = effect_name_v
	e.value = v
	return e

## 【持续存在】型效果 [br]
## [period_time_ms] 生效周期，负数表示不生效，生效时增加堆叠层数 [br]
## [max_stack_v] 堆叠层数上限 [br]
func new_period(from_name_v: StringName, effect_name_v: StringName, v: float, duration_time_s: float, period_time_ms := -1, max_stack_v := 1) -> Effect:
	var e := Effect.new()
	e.from_name = from_name_v
	e.effect_name = effect_name_v
	e.value = v

	e.duration_timer = TinyTimer.new()
	e.duration_timer.set_limit(duration_time_s)
	e.period_ms = period_time_ms
	e.max_stack = max_stack_v

	return e

#endregion
