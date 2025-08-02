class_name ConditionStateBase
extends Node

func will_enter() -> bool:
	return false

## 只能放幂等性的逻辑
func on_enter() -> void:
	pass

## 只能放幂等性的逻辑
func on_exit() -> void:
	pass

func tick(_delta: float) -> void:
	push_error("tick for base state")
