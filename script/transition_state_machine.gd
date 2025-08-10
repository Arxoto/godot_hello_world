class_name TransitionStateMachine
extends Node

@export var default_state: TransitionStateBase = TransitionStateBase.new()
var current_state: TransitionStateBase

var state_map: Dictionary[String, TransitionStateBase] = {}

#region state_map

func register(state_name: String, s: TransitionStateBase):
	state_map[state_name] = s

func get_state(s: String) -> TransitionStateBase:
	return state_map.get(s)

#endregion

func _ready() -> void:
	current_state = default_state
	current_state.on_ready_enter()

func tick_frame(delta: float) -> void:
	var state: TransitionStateBase = current_state.tick_frame(delta)
	if state:
		# print("%s/%s, when tick_frame, %s: %s -> %s" % [Engine.get_process_frames(), Engine.get_physics_frames(), get_parent().name, current_state.name, state.name])
		change_state(state)

## 该状态机适合实现分层状态机 但需要注意状态不能返回自身或子类
## 分层状态机通过父类继承实现 通过在父类状态存储状态映射实现状态跳转时的引用（每个父类都得实现一遍防止污染）
## 因为调用顺序 逻辑中必须先处理后返回 否则会少一次 tick
func tick_physics(delta: float) -> void:
	var state: TransitionStateBase = current_state.tick_physics(delta)
	if state:
		# print("%s/%s, when tick_physics, %s: %s -> %s" % [Engine.get_process_frames(), Engine.get_physics_frames(), get_parent().name, current_state.name, state.name])
		change_state(state)

func change_state(state: TransitionStateBase):
	current_state.on_exit()
	current_state = state
	current_state.on_enter()
