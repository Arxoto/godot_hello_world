class_name StateComboSuper
extends TransitionStateBase

@onready var outer_state: StateCombo = $"../../"

var character: PlayerCharacter

func _ready() -> void:
	character = owner

func tick_frame(_delta: float) -> TransitionStateBase:
	if character.anim_player.not_combo():
		return state(StateComboIdle.STATE_NAME)
	return null
