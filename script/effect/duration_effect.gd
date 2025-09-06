## 持续存在型效果
class_name DurationEffect
extends Effect

## 存在计时（仅非瞬发生效）
var life_time := 0.0
## 持续时间 零和负数表示无限存在
var duration_time := 0.0
## 生效周期 零和负数表示不重复生效
var period_time := 0.0
## 生效等待时间
var wait_time := 0.0

## 堆叠层数 重新添加效果时触发
var stack := 1
## 堆叠上限 不支持无上限
var max_stack := 1

#region newer

## 【持续存在】型效果
static func new_duration(from_name_v: StringName, effect_name_v: StringName, v: float) -> DurationEffect:
	var de := DurationEffect.new()
	de.from_name = from_name_v
	de.effect_name = effect_name_v
	de.value = v
	return de

## 设置堆叠上限
func with_max_stack(v: int) -> DurationEffect:
	max_stack = v
	return self

## 设置持续时间 零和负数表示无限存在
func with_duration(v: float) -> DurationEffect:
	duration_time = v
	return self

## 设置生效周期 零和负数表示不重复生效
func with_period(v: float) -> DurationEffect:
	period_time = v
	return self

## 设置生效等待时间
func with_wait(v: float) -> DurationEffect:
	wait_time = v
	return self

#endregion

#region func

## 是否无限存在
func is_infinite() -> bool:
	return duration_time <= 0

## 是否持续一段时间
func is_duration() -> bool:
	return duration_time > 0

## 是否周期生效
func is_period() -> bool:
	return period_time > 0

## 重新开始计时
func restart_life():
	life_time = 0.0

## 是否过期
func is_expired() -> bool:
	if not is_duration():
		return false
	return life_time >= duration_time

## 当前时间总共生效次数
func period_counts() -> int:
	var life_t := duration_time if is_expired() else life_time
	if life_t > wait_time:
		return ((life_t - wait_time) / period_time) as int
	return 0

## 处理时间 返回周期生效次数
func process_period(delta: float) -> int:
	if is_expired():
		return 0
	
	if not is_period():
		life_time += delta
		return 0
	
	var old_count := period_counts()
	life_time += delta
	return period_counts() - old_count

## 尝试叠加 返回叠加后的层数
func add_stack(c: int) -> int:
	stack = min(max_stack, stack + c)
	return stack

## 刷新并堆叠 返回叠加后的层数
func refresh_and_add_stack(de: DurationEffect) -> int:
	self.from_name = de.from_name
	self.value = de.value
	# 延迟和周期等不重置 以此顺序可最大收益 高频次-高层数-高加成
	restart_life()
	return add_stack(de.stack)

func restart_effect(e: Effect):
	self.from_name = e.from_name
	restart_life()

#endregion
