class_name StateComboSuper
extends TransitionStateBase

static var state_map: Dictionary[String, TransitionStateBase] = {}

static func register(state_name: String, s: TransitionStateBase):
	state_map[state_name] = s

static func state(s: String) -> TransitionStateBase:
	return state_map.get(s)

@onready var outer_state: StateCombo = $"../"

var character: PlayerCharacter

func _ready() -> void:
	character = owner

func tick_frame(_delta: float) -> TransitionStateBase:
	if character.anim_player.not_combo():
		return state(StateComboIdle.STATE_NAME)
	return null
