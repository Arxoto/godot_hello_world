class_name ConditionStateMachine
extends Node

@export var default_state: ConditionStateBase = ConditionStateBase.new()
var current_state: ConditionStateBase

func _ready() -> void:
	use_default_state()

func use_default_state() -> void:
	if current_state:
		current_state.on_exit()
	current_state = default_state
	current_state.on_enter()

## 使用时将状态机挂载到角色下 将状态挂载到状态机下
func update_state() -> void:
	# print(Engine.get_physics_frames(), " current_state ", current_state.name)
	for state: ConditionStateBase in get_children():
		if state.will_enter():
			if state != current_state:
				print("%s, %s: %s -> %s" % [Engine.get_physics_frames(), get_parent().name, current_state.name, state.name])
				current_state.on_exit()
				current_state = state
				current_state.on_enter()
			return
	
	use_default_state()

func tick(delta: float) -> void:
	current_state.tick(delta)
