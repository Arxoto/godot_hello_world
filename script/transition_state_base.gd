class_name TransitionStateBase
extends Node

func on_enter() -> void:
	pass

func on_exit() -> void:
	pass

func tick_frame(_delta: float) -> void:
	pass

func tick_physics(_delta: float) -> TransitionStateBase:
	return null
