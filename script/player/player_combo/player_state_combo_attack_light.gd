class_name StateComboAttackLight
extends StateComboSuper

const STATE_NAME = "attack_light"

# 导出变量，由动画控制，代码中只读（除初始化）
@export var can_attack_twice := false
var want_attack_twice := false

## 持续摁住攻击键 超过一定时间后进行重击
@export var heavy_attack_time_limit := 0.2
var heavy_attack_timer := TinyTimer.new()

func get_state_name() -> String:
	return STATE_NAME

func on_enter() -> void:
	super.on_enter()

	can_attack_twice = false
	want_attack_twice = false
	heavy_attack_timer.set_limit(heavy_attack_time_limit)
	heavy_attack_timer.start_time()

	character.anim_player.play_once_anim(character.anim_player.anim_attack_1)

func tick_frame(delta: float) -> TransitionStateBase:
	if character.want_attack_once():
		want_attack_twice = true
	if want_attack_twice and can_attack_twice:
		return state(StateComboAttackTwice.STATE_NAME)

	if character.want_attack_keep():
		heavy_attack_timer.add_time(delta)
		if heavy_attack_timer.end():
			return state(StateComboAttackHeavy.STATE_NAME)
	else:
		heavy_attack_timer.final_time()
	
	return super.tick_frame(delta)
