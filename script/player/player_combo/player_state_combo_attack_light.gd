class_name StateComboAttackLight
extends StateComboSuper

const STATE_NAME = "attack_light"

func _ready() -> void:
	super._ready()
	register(STATE_NAME, self)

var want_attack_twice := false
var want_heavy_attack := true

func on_enter() -> void:
	super.on_enter()

	want_attack_twice = false
	want_heavy_attack = true

	character.anim_player.play_once_anim(character.anim_player.anim_attack_1)

func tick_frame(delta: float) -> TransitionStateBase:
	if character.want_dodge() and outer_state.can_dodge:
		character.echo_dodge()
		return state(StateComboDodge.STATE_NAME)
	
	if character.want_block_keep() and outer_state.can_block:
		return state(StateComboBlock.STATE_NAME)
	
	want_attack_twice = want_attack_twice or character.want_attack_once() # 重新摁下一次，到时间窗后即可触发连击
	if want_attack_twice and outer_state.can_attack_twice:
		return state(StateComboAttackTwice.STATE_NAME)

	want_heavy_attack = want_heavy_attack and character.want_attack_keep() # 持续摁住直到到达时间窗，触发重击
	if want_heavy_attack and outer_state.can_heavy_attack:
		return state(StateComboAttackHeavy.STATE_NAME)
	
	return super.tick_frame(delta)
