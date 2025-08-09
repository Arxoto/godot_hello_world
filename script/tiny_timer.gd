class_name TinyTimer
extends RefCounted

var time_value := 0.0
var time := 0.0
## 时间流动
var flow := false

func set_limit(t: float):
	time_value = t

## 开始计时
func start_time():
	flow = true
	time = 0.0

## 强制结束
func final_time():
	flow = false

## 时间流逝
func add_time(delta: float):
	if flow:
		time = min(time + delta, time_value)

## 计时进行中 未结束
func in_time() -> bool:
	return flow and time < time_value

## 时间自然结束
func end() -> bool:
	return flow and time >= time_value

## 时间被强制结束
func forced_final() -> bool:
	return not flow
