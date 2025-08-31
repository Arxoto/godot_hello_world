class_name StateInAir
extends PlayerState

@export var inner_state_combo: StateCombo

# 问题：边缘无法跳跃
# 分析：边缘之外才尝试跳跃，此时因为在空中无法进行跳跃
# 预期：刚走出边缘的一段时间内允许跳跃
# 分析：定义走出边缘：不是通过跳跃进入空中的
# 实现：检测上一帧是否尝试跳跃，基本等价于检测这一帧有无向上速度
# 例外：跳跃了但无速度：上一帧跳跃但是碰撞，本帧无碰撞仍然可跳（无所谓）
# 例外：没跳跃但有速度：上一帧非主观原因导致升空，存在逻辑错误（用另一个状态区分可控不可控）
@export var coyote_time_value := 0.1
var coyote_timer := TinyTimer.new()

var jump_higher_timer := TinyTimer.new()

var double_jump_value: int
var double_jump := 0

func _ready():
	super._ready()
	coyote_timer.set_limit(coyote_time_value)
	jump_higher_timer.set_limit(character.jump_higher_time_value())
	double_jump_value = character.double_jump_value()

func will_enter() -> bool:
	return not character.is_on_floor()

func on_enter() -> void:
	super.on_enter()

	if jump_into_air():
		jump_higher_timer.start_time()
		coyote_timer.final_time()
	else:
		coyote_timer.start_time()
		jump_higher_timer.final_time()
	
	start_double_jump()

#region jump_higher

func jump_into_air() -> bool:
	# 为什么这么实现详见 coyote_time
	var v_y := character.velocity.y
	return not is_zero_approx(v_y) and v_y < 0

func do_jump_normal() -> void:
	jump_higher_timer.start_time()
	character.do_jump_normal()

func do_jump_higher_fall(delta: float) -> void:
	# print("%s: jump_higher !!!" % Engine.get_physics_frames())
	character.do_fall(delta, character.fall_velocity(), character.jump_higher_gravity_scale())

func do_fall(delta: float) -> void:
	character.do_fall(delta, character.fall_velocity(), character.fall_gravity_scale())

# func do_fly() -> void:
# 	var fly_time := 0.5
# 	var fly_time_value := 1.0
# 	var speed_min := character.fly_velocity_min()
# 	var speed_max := character.fly_velocity_max()
# 	var speed := lerpf(speed_min, speed_max, fly_time / fly_time_value)
# 	character.do_jump(speed)

#endregion

#region jump_on_wall

## 优化攀爬时的体验
## 扩展能力：伸出式平台（壁架）边缘呈倒阶梯状，操作得当时可以逆攀而上
##     每个台阶2高度不依赖二段跳，1高度依赖二段跳（若蹬墙跳的判断仅仅为与墙碰撞，则极限操作也可以）

func can_jump_on_wall() -> bool:
	return character.foot_on_wall()

#endregion

#region double_jump

func start_double_jump() -> void:
	double_jump = 0

func can_double_jump() -> bool:
	return double_jump < double_jump_value

func add_double_jump() -> void:
	double_jump = min(double_jump + 1, double_jump_value)

#endregion

func tick_jump(delta: float) -> void:
	if character.want_jump_once() and inner_state_combo.can_jump:
		if can_jump_on_wall():
			print("%s: jump on wall !!!" % Engine.get_physics_frames())
			do_jump_normal()
			return
		elif coyote_timer.in_time():
			print("%s: coyote time !!!" % Engine.get_physics_frames())
			do_jump_normal()
			return
		elif can_double_jump():
			print("%s: double jump !!!" % Engine.get_physics_frames())
			add_double_jump()
			do_jump_normal()
			return
	elif character.want_jump_higher() and inner_state_combo.can_jump_higher:
		if jump_higher_timer.in_time():
			do_jump_higher_fall(delta)
			return
	else:
		jump_higher_timer.final_time()
	
	do_fall(delta)

func tick_move(delta: float):
	if inner_state_combo.do_dodge:
		character.do_dodge(delta, inner_state_combo.do_fast_dodge)
	elif character.want_move() and inner_state_combo.can_move:
		character.do_move(delta, character.want_move_direction * character.air_speed(), character.air_acceleration())
	else:
		character.do_move(delta, 0, character.air_resistance())
	
	if inner_state_combo.can_turn: play_turn()

func tick_physics(delta: float) -> void:
	jump_higher_timer.add_time(delta)
	coyote_timer.add_time(delta)
	if can_jump_on_wall():
		coyote_timer.start_time()

	tick_jump(delta)
	tick_move(delta)
	
	# 不要过渡动画 jump_to_fall 动作有个莫名的甩刀不好看
	if character.velocity.y < 0:
		play_loop_anim(character.anim_player.anim_jump)
	else:
		play_loop_anim(character.anim_player.anim_fall)

func tick_frame(delta: float) -> void:
	inner_state_combo.tick_frame(delta)
