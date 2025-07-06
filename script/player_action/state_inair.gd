class_name StateInAir
extends StateCharacter

@export var jump_higher_time_value := 0.1
var jump_higher_time := 0.0
@export var coyote_time_value := 0.1
var coyote_time := 0.0
@export var prejump_time_value := 0.1
var prejump_time := 0.0
@export var double_jump_value := 0
var double_jump := 0

func will_enter() -> bool:
	return not character.is_on_floor()

func on_enter() -> void:
	if jump_into_air():
		start_jump_higher_time()
		final_coyote_time()
	else:
		start_coyote_time()
		final_jump_higher_time()
	
	final_prejump_time()
	start_double_jump()

func on_exit() -> void:
	if can_prejump():
		print("%s: prejump !!!" % Engine.get_physics_frames())
		do_jump_first()

#region jump

func jump_into_air() -> bool:
	# 为什么这么实现详见 coyote_time
	var v_y := character.velocity.y
	return not is_zero_approx(v_y) and v_y < 0

func start_jump_higher_time() -> void:
	jump_higher_time = 0.0

func final_jump_higher_time() -> void:
	jump_higher_time = jump_higher_time_value

func add_jump_higher_time(delta: float) -> void:
	jump_higher_time = min(jump_higher_time + delta, jump_higher_time_value)

func can_jump_higher() -> bool:
	return jump_higher_time < jump_higher_time_value

func do_jump_first() -> void:
	start_jump_higher_time()
	character.do_jump(character.jump_velocity_min())

func do_jump_higher() -> void:
	var speed_min := character.jump_velocity_min()
	var speed_max := character.jump_velocity_max()
	var speed := lerpf(speed_min, speed_max, jump_higher_time / jump_higher_time_value)
	character.do_jump(speed)

#endregion

#region coyote_time

# 问题：边缘无法跳跃
# 分析：边缘之外才尝试跳跃，此时因为在空中无法进行跳跃
# 预期：刚走出边缘的一段时间内允许跳跃
# 分析：定义走出边缘：不是通过跳跃进入空中的
# 实现：检测上一帧是否尝试跳跃，基本等价于检测这一帧有无向上速度
# 例外：跳跃了但无速度：上一帧跳跃但是碰撞，本帧无碰撞仍然可跳

func start_coyote_time() -> void:
	coyote_time = 0.0

func final_coyote_time() -> void:
	coyote_time = coyote_time_value

func add_coyote_time(delta: float) -> void:
	coyote_time = min(coyote_time + delta, coyote_time_value)

func can_coyote_jump() -> bool:
	return coyote_time < coyote_time_value

#endregion

#region prejump_time

# 问题：落地瞬间尝试跳跃失败
# 分析：空中尝试跳跃失败，地面上没有尝试跳跃
# 预期：尝试跳跃并失败后的一段时间内，接触地面的一瞬间自动进行跳跃
# 分析：定义跳跃并失败：空中尝试跳跃，其他情况不考虑
# 实现：空中尝试跳跃则开始计时，退出空中状态时进行跳跃

func start_prejump_time() -> void:
	prejump_time = 0.0

func final_prejump_time() -> void:
	prejump_time = prejump_time_value

func add_prejump_time(delta: float) -> void:
	prejump_time = min(prejump_time + delta, prejump_time_value)

func can_prejump() -> bool:
	return prejump_time < prejump_time_value

#endregion

#region double_jump

func start_double_jump() -> void:
	double_jump = 0

func can_double_jump() -> bool:
	return double_jump < double_jump_value

func add_double_jump() -> void:
	double_jump = min(double_jump + 1, double_jump_value)

#endregion

func tick(delta: float) -> void:
	if character.want_move():
		character.do_move(delta, character.want_move_direction * character.air_speed(), character.air_acceleration())
	else:
		character.do_move(delta, 0, character.air_resistance())
	
	add_jump_higher_time(delta)
	add_coyote_time(delta)
	add_prejump_time(delta)

	var jumped := false
	if character.want_jump_once():
		start_prejump_time()
		if can_coyote_jump():
			print("%s: coyote time !!!" % Engine.get_physics_frames())
			do_jump_first()
			jumped = true
		elif can_double_jump():
			print("%s: double jump !!!" % Engine.get_physics_frames())
			add_double_jump()
			do_jump_first()
			jumped = true
	elif character.want_jump_higher():
		if can_jump_higher():
			do_jump_higher()
			jumped = true
	else:
		final_jump_higher_time()
	
	if not jumped:
		character.do_fall(delta, character.fall_velocity(), character.fall_gravity_scale())

func play() -> void:
	character.play_turn()
	character.animation_player.play("jump")
