class_name StateLand
extends TransitionStateBase

static var state_map: Dictionary[String, StateLand] = {}

var character: CharacterLand

func _ready() -> void:
	character = owner

func register(state_name: String):
	state_map[state_name] = self

func state(s: String) -> StateLand:
	return state_map.get(s)
