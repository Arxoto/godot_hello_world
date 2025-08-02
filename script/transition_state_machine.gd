class_name TransitionStateMachine
extends Node

@export var default_state: TransitionStateBase = TransitionStateBase.new()
var current_state: TransitionStateBase

func _ready() -> void:
	change_state(default_state)

func change_state(state: TransitionStateBase) -> void:
	current_state.on_exit()
	current_state = state
	current_state.on_enter()

func tick(delta: float) -> void:
	var state: TransitionStateBase = current_state.tick(delta)
	if state: change_state(state)
