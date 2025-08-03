class_name ConditionStateBase
extends Node

## 只能放纯函数 不能有副作用
func will_enter() -> bool:
	return false

## 只能放幂等性的逻辑（状态机里判断状态一致其实无需幂等）
func on_enter() -> void:
	pass

## 只能放幂等性的逻辑（状态机里判断状态一致其实无需幂等）
func on_exit() -> void:
	pass

func tick_input(_event: InputEvent) -> void:
	pass

func tick_frame(_delta: float) -> void:
	pass

func tick_physics(_delta: float) -> void:
	pass
