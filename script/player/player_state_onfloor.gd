class_name StateOnFloor
extends PlayerState

@export var stand_jump_time_value := 0.1
var stand_jump_time: float

#region stand_jump_time

func start_jump_timer():
	if stand_jump_time < 0.0:
		stand_jump_time = 0.0

func final_jump_timer():
	stand_jump_time = -1.0 # 用负数表示不跳跃

func add_jump_time(delta: float):
	if stand_jump_time >= 0.0:
		stand_jump_time = min(stand_jump_time + delta, stand_jump_time_value)

func can_jump() -> bool:
	return stand_jump_time >= stand_jump_time_value

#endregion

func will_enter() -> bool:
	return character.is_on_floor()

func on_enter() -> void:
	super.on_enter()
	final_jump_timer() # tick 在 enter 之后 可以无脑初始化 也无需 exit 时处理 因为状态切换必定先执行 enter

func tick_physics(delta: float) -> void:
	# 仅站立不动时播放完整起跳动画
	if not character.want_move() and character.want_jump_once():
		play_once_anim(anim_floor_to_jump) # 动画调用 character.do_jump_normal() 也可以 但是允许连续摁下刷新起跳状态导致无法跳跃（很难）
		start_jump_timer()

	add_jump_time(delta)
	# 站立时延迟跳跃 动作连贯  移动时立即起跳 操作连贯
	if can_jump() or character.want_move() and character.want_jump_once():
		final_jump_timer()
		character.do_jump_normal() # 仅一个地方控制跳跃效果 防止重复生效
	
	# 移动时跳跃 立即生效 与下面三个各个阶段覆盖，判断有无bug
	# 站立时跳跃 开始计时 互斥，不可能同时生效
	# 站立时跳跃 持续计时 结束计时并立即跳跃
	# 站立时跳跃 结束计时 同一判断条件，不会重复生效

	if character.want_move():
		character.do_move(delta, character.want_move_direction * character.run_speed(), character.run_acceleration())
	else:
		character.do_move(delta, 0, character.run_resistance())
	
	character.play_turn()
	if not is_zero_approx(character.velocity.x):
		play_loop_anim(anim_run)
	else:
		play_loop_anim(anim_idle)
