class_name StateComboIdle
extends StateComboSuper

const STATE_NAME = "idle"

func get_state_name() -> String:
	return STATE_NAME

func on_ready_enter() -> void:
	return

func on_enter() -> void:
	super.on_enter()
	character.anim_player.stop_anim()

func tick_frame(_delta: float) -> TransitionStateBase:
	if character.want_block_keep():
		return state(StateComboBlock.STATE_NAME)
	if character.want_attack_once():
		return state(StateComboAttackLight.STATE_NAME)
	return null
