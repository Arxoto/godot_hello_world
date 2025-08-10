class_name PlayerState
extends ConditionStateBase

var character: PlayerCharacter

func _ready() -> void:
	character = owner

func on_enter() -> void:
	super.on_enter()
	transition()

func on_exit() -> void:
	super.on_exit()

func transition() -> void:
	# print("state transition ", source + "-" + target)
	match source + "-" + target:
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
