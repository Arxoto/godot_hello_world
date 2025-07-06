class_name StateBase
extends Node

func will_enter() -> bool:
	return false

## 只能放幂等性的逻辑
func on_enter() -> void:
	pass

## 只能放幂等性的逻辑
func on_exit() -> void:
	pass

## 状态的行为效果
func tick(_delta: float) -> void:
	push_error("tick for base state")

## 状态的行为表现
func play() -> void:
	push_error("play for base state")
