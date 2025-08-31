class_name StateOnFloor
extends PlayerState

@export var inner_state_combo: StateCombo

var stand_to_jump_delay_timer := TinyTimer.new()
@export var stand_to_jump_delay_value := 0.1

func _ready():
	super._ready()
	stand_to_jump_delay_timer.set_limit(stand_to_jump_delay_value)

func will_enter() -> bool:
	return character.is_on_floor()

func on_enter() -> void:
	super.on_enter()
	stand_to_jump_delay_timer.final_time()

func tick_jump(delta: float):
	# 若无法跳跃 重新计时
	if not inner_state_combo.can_jump:
		stand_to_jump_delay_timer.final_time()
		return
	
	# 移动时立即起跳 操作连贯
	if character.want_move() and character.want_jump_once():
		stand_to_jump_delay_timer.final_time()
		character.do_jump_normal()
		return

	# 站立时延迟跳跃 动作连贯
	if not character.want_move() and character.want_jump_once():
		# 仅第一次触发计时
		if stand_to_jump_delay_timer.is_forced_final():
			play_once_anim(character.anim_player.anim_floor_to_jump)
			stand_to_jump_delay_timer.start_time()
			character.echo_jump() # 提前通知跳跃动作

	stand_to_jump_delay_timer.add_time(delta)
	if stand_to_jump_delay_timer.end():
		stand_to_jump_delay_timer.final_time()
		character.do_jump_normal()
	
	# 移动时跳跃 立即生效 与下面三个各个阶段覆盖，判断有无bug
	# 站立时跳跃 开始计时 互斥，不可能同时生效
	# 站立时跳跃 持续计时 结束计时并立即跳跃
	# 站立时跳跃 结束计时 不会重复生效

func tick_move(delta: float):
	if inner_state_combo.do_dodge:
		character.do_dodge(delta, inner_state_combo.do_fast_dodge)
	elif character.want_move() and inner_state_combo.can_move:
		character.do_move(delta, character.want_move_direction * character.run_speed(), character.run_acceleration())
	else:
		character.do_move(delta, 0, character.run_resistance())
	
	if inner_state_combo.can_turn: play_turn()

func tick_physics(delta: float) -> void:
	tick_jump(delta)
	tick_move(delta)

	if not is_zero_approx(character.velocity.x):
		play_loop_anim(character.anim_player.anim_run)
	else:
		play_loop_anim(character.anim_player.anim_idle)

func tick_frame(delta: float) -> void:
	inner_state_combo.tick_frame(delta)
