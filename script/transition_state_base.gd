class_name TransitionStateBase
extends Node

func on_enter() -> void:
	pass

func on_exit() -> void:
	pass

func tick(_delta: float) -> TransitionStateBase:
	push_error("tick for base state")
	return null
