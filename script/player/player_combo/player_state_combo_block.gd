class_name StateComboBlock
extends StateComboSuper

const STATE_NAME = "block"

## 完美防御时间
@export var perfect_block_time_limit := 0.1
var perfect_block_timer := TinyTimer.new()

func get_state_name() -> String:
	return STATE_NAME

func in_perfect_block() -> bool:
	return perfect_block_timer.in_time()

func on_enter() -> void:
	super.on_enter()

	perfect_block_timer.set_limit(perfect_block_time_limit)
	perfect_block_timer.start_time()
	
	character.anim_player.play_once_anim(character.anim_player.anim_block_0)

func tick_frame(delta: float) -> TransitionStateBase:
	perfect_block_timer.add_time(delta)
	if perfect_block_timer.in_time():
		print("perfect_block time !!!")
	
	character.anim_player.play_loop_anim(character.anim_player.anim_block_1)

	if character.want_attack_once():
		return state(StateComboBlockAttack.STATE_NAME)
	
	if not character.want_block_keep():
		return state(StateComboIdle.STATE_NAME)
	
	return super.tick_frame(delta)
