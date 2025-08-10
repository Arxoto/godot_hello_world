class_name TransitionStateBase
extends Node

@onready var state_machine: TransitionStateMachine = $"../"

func register(state_name: String, s: TransitionStateBase):
	state_machine.register(state_name, s)

func state(s: String) -> TransitionStateBase:
	return state_machine.get_state(s)

## 仅状态机初始化时执行 防止状态机启动时生命周期导致空指针报错
func on_ready_enter() -> void:
	push_error("impl on_ready_enter: ", name)

func on_enter() -> void:
	pass

func on_exit() -> void:
	pass

func tick_frame(_delta: float) -> TransitionStateBase:
	return null

func tick_physics(_delta: float) -> TransitionStateBase:
	return null
