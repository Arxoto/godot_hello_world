class_name TransitionStateMachine
extends Node

@export var default_state: TransitionStateBase = TransitionStateBase.new()
var current_state: TransitionStateBase

func _ready() -> void:
	current_state = default_state
	current_state.on_enter()

func tick_frame(delta: float) -> void:
	current_state.tick_frame(delta)

## 该状态机适合实现分层状态机 但需要注意状态不能返回自身或子类
## 分层状态机通过父类继承实现 需在节点树依次设置对应跳转节点（状态多时很麻烦）
func tick_physics(delta: float) -> void:
	var state: TransitionStateBase = current_state.tick_physics(delta)
	if state:
		print("%s/%s, %s: %s -> %s" % [Engine.get_process_frames(), Engine.get_physics_frames(), get_parent().name, current_state.name, state.name])
		current_state.on_exit()
		current_state = state
		current_state.on_enter()
