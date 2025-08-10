class_name StateComboBlock
extends StateComboSuper

const STATE_NAME = "block"

func _ready() -> void:
	super._ready()
	register(STATE_NAME, self)

func on_enter() -> void:
	super.on_enter()
	
	character.anim_player.play_once_anim(character.anim_player.anim_block_0)

func tick_frame(delta: float) -> TransitionStateBase:
	character.anim_player.play_loop_anim(character.anim_player.anim_block_1)

	if character.want_attack_once():
		print("asdasd  ", outer_state.can_block_attack)
	if character.want_attack_once() and outer_state.can_block_attack:
		return state(StateComboBlockAttack.STATE_NAME)
	
	if not character.want_block_keep():
		return state(StateComboIdle.STATE_NAME)
	
	return super.tick_frame(delta)
