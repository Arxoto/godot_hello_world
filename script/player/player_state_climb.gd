class_name StateClimb
extends PlayerState

func will_enter() -> bool:
	return can_climb()

func upping() -> bool:
	var v_y := character.velocity.y
	return not is_zero_approx(v_y) and v_y < 0

func can_climb() -> bool:
	if upping():
		return false
	if not character.is_on_wall() or character.is_on_floor():
		return false
	
	if not character.hand_on_wall() or not character.foot_on_wall():
		return false
	
	# can climb 墙面法线和移动方向必须相反，使用点积计算投影
	var wall_normal := character.get_wall_normal()
	var move_vector := Vector2(character.want_move_direction, 0)
	var valid_dot := wall_normal.dot(move_vector)

	return not is_zero_approx(valid_dot) && valid_dot < 0

func tick_physics(delta: float) -> void:
	# 当没有横向速度时 左右墙的is_on_wall结果不一致 应该是BUG 给予一个速度强制碰撞
	if character.want_move():
		character.do_move(delta, character.want_move_direction * character.air_speed(), character.air_acceleration())
	
	if character.want_jump_once():
		print("%s: jump on climb !!!" % Engine.get_physics_frames())
		character.do_jump_normal()
	else:
		character.do_fall(delta, character.climb_velocity(), character.climb_gravity_scale())
	
	play_turn()
	play_loop_anim(character.anim_player.anim_climb)
