class_name StateComboBlockAttack
extends StateComboSuper

const STATE_NAME = "block_attack"

func get_state_name() -> String:
	return STATE_NAME

func on_enter() -> void:
	super.on_enter()
	character.anim_player.play_once_anim(character.anim_player.anim_attack_3)
	print("block_attack!!! todo play anim")
