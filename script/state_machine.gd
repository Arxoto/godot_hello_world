class_name StateMachine
extends Node

@export var default_state: StateBase = StateBase.new()
var current_state: StateBase

func _ready() -> void:
	use_default_state()

func use_default_state() -> void:
	if current_state:
		current_state.on_exit()
	current_state = default_state
	current_state.on_enter()

func update_state() -> void:
	# print(current_state.name)
	for state: StateBase in get_children():
		if state.will_enter():
			if state != current_state:
				print("%s: %s -> %s" % [Engine.get_physics_frames(), current_state.name, state.name])
				current_state.on_exit()
				current_state = state
				current_state.on_enter()
			return
	
	use_default_state()

func tick(delta: float) -> void:
	current_state.tick(delta)

func play() -> void:
	current_state.play()
