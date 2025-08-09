class_name StateComboAttackTwice
extends StateComboSuper

const STATE_NAME = "attack_twice"

func get_state_name() -> String:
	return STATE_NAME

func on_enter() -> void:
	super.on_enter()
	character.anim_player.play_once_anim(character.anim_player.anim_attack_2)
