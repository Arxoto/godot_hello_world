class_name StateComboIdle
extends StateComboSuper

const STATE_NAME = "idle"

func _ready() -> void:
	super._ready()
	register(STATE_NAME, self)

func on_ready_enter() -> void:
	return

func on_enter() -> void:
	super.on_enter()
	character.anim_player.stop_anim()

func tick_frame(_delta: float) -> TransitionStateBase:
	if character.want_dodge() and outer_state.can_dodge:
		character.echo_dodge()
		return state(StateComboDodge.STATE_NAME)
	if character.want_block_keep() and outer_state.can_block:
		return state(StateComboBlock.STATE_NAME)
	if character.want_attack_once() and outer_state.can_attack:
		return state(StateComboAttackLight.STATE_NAME)
	return null
