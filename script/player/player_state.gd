class_name PlayerState
extends ConditionStateBase

var character: PlayerCharacter

static var source: String
static var targte: String

func _ready() -> void:
	character = owner

func on_enter() -> void:
	targte = name
	transition()

func on_exit() -> void:
	source = name

func transition() -> void:
	# print("state transition ", source + "-" + targte)
	match source + "-" + targte:
		"InAir-OnFloor":
			play_once_anim(character.anim_player.anim_fall_to_floor)
		"InAir-Climb":
			play_once_anim(character.anim_player.anim_air_to_climb)

#region play_anim

func play_turn() -> void:
	character.play_turn()

func play_once_anim(anim: String) -> void:
	character.play_once_anim(anim)

func play_loop_anim(anim: String) -> void:
	character.play_loop_anim(anim)

#endregion
