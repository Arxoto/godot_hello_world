class_name StateClimb
extends PlayerState

@export var inner_state_combo: StateCombo

func will_enter() -> bool:
	return can_climb()

func can_climb() -> bool:
	if character.velocity.y < 0: # 这里没必要很严谨 不需要 is_zero_approx
		return false
	if not character.is_on_wall() or character.is_on_floor():
		return false
	
	if not character.hand_on_wall() or not character.foot_on_wall():
		return false
	
	# can climb 墙面法线和移动方向必须相反，使用点积计算投影
	# 这里使用了意图进行判断 与约定的使用客观条件进行判断不符 但是因为判断进入条件是在逻辑开头 此时还未赋予速度 且因为靠墙导致上一帧碰撞后速度为零
	# todo 把跳跃操作冗余迁移到意图判断中 也许可以将约定取消
	var move_vector := Vector2(character.want_move_direction, 0)
	var wall_normal := character.get_wall_normal()
	var valid_dot := wall_normal.dot(move_vector)

	return not is_zero_approx(valid_dot) and valid_dot < 0

func tick_physics(delta: float) -> void:
	if character.want_jump_once() and inner_state_combo.can_jump:
		print("%s: jump on climb !!!" % Engine.get_physics_frames())
		character.do_jump_normal()
	else:
		character.do_fall(delta, character.climb_velocity(), character.climb_gravity_scale())
	
	# 当没有横向速度时 左右墙的is_on_wall结果不一致 应该是BUG 给予一个速度强制碰撞
	if character.want_move() and inner_state_combo.can_move:
		character.do_move(delta, character.want_move_direction * character.air_speed(), character.air_acceleration())
	
	play_turn()
	
	play_loop_anim(character.anim_player.anim_climb)

func tick_frame(delta: float) -> void:
	inner_state_combo.tick_frame(delta)
