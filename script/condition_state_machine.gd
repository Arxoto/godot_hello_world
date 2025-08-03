class_name ConditionStateMachine
extends Node

@export var default_state: ConditionStateBase = ConditionStateBase.new()
var current_state: ConditionStateBase
var state_list: Array[Node]

func _ready() -> void:
	use_default_state()
	state_list = get_children()

func use_default_state() -> void:
	if current_state:
		current_state.on_exit()
	current_state = default_state
	current_state.on_enter()

## 使用时将状态机挂载到角色下 将状态挂载到状态机下 由调用方决定在什么时候调用状态更新
## 该状态机一致性较强 状态之间的转换解耦合 但是状态之间的转换不灵活（动画过渡已有方案，但是涉及物理效果等不好实现）
func update_state() -> void:
	# print(Engine.get_physics_frames(), " current_state ", current_state.name)
	for state: ConditionStateBase in state_list:
		if state.will_enter():
			if state != current_state:
				print("%s/%s, %s: %s -> %s" % [Engine.get_process_frames(), Engine.get_physics_frames(), get_parent().name, current_state.name, state.name])
				current_state.on_exit()
				current_state = state
				current_state.on_enter()
			return
	
	use_default_state()

## 仅按键响应，非物理
func tick_input(event: InputEvent) -> void:
	current_state.tick_input(event)

## 仅每帧响应，非物理
func tick_frame(delta: float) -> void:
	current_state.tick_frame(delta)

## 仅物理相关
func tick_physics(delta: float) -> void:
	current_state.tick_physics(delta)
