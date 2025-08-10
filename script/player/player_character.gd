class_name PlayerCharacter
extends CharacterBody2D

## 重力加速度
var base_gravity := ProjectSettings.get("physics/2d/default_gravity") as float

@onready var body: Node2D = $TheBody
@onready var anim_player: PlayerAnimPlayer = $PlayerAnimPlayer
@onready var state_machine: ConditionStateMachine = $ConditionStateMachine
@onready var hand_line: RayCast2D = $TheBody/HandLine
@onready var foot_line: RayCast2D = $TheBody/FootLine

@export var movement_data: PlayerMovementData

## 仅有激活（摁住）和释放（不摁）状态，不涉及摁下和抬起
var want_look_angle: float
## 仅有激活（摁住）和释放（不摁）状态，不涉及摁下和抬起
var want_move_direction: float

## 摁下触发 once 一段攻击的开始
var want_attack_once_flag := false
## 摁住激活 keep 一段攻击的蓄力
var want_attack_keep_flag := false
## 摁住激活 防御姿态
var want_block_keep_flag := false

## 摁下触发 once 意为开始一段跳跃，摁下直到抬起视为一次跳跃
var want_jump_once_flag := false
## 摁住激活 higher 意为跳得更高，摁下直到抬起视为一次跳跃
var want_jump_higher_flag := false

# var want_dodge_flag := false
# 闪避的容错时间 发现放在意图中更合适 后面可能会将跳跃一起迁过来 合并 coyote_timer prejump_timer
## 摁下触发 闪避/冲刺
var dodge_delay_timer := TinyTimer.new()
@export var dodge_delay_value := 0.1

const INPUT_MOVE_LEFT := "move_left"
const INPUT_MOVE_RIGHT := "move_right"
const INPUT_LOOK_UP := "look_up"
const INPUT_LOOK_DOWN := "look_down"
const INPUT_JUMP := "jump"
const INPUT_DODGE := "dodge"
const INPUT_ATTACK := "attack"
const INPUT_BLOCK := "block"

func _ready():
	dodge_delay_timer.set_limit(dodge_delay_value)
	dodge_delay_timer.final_time()

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed(INPUT_DODGE):
		dodge_delay_timer.start_time()

func _process(delta: float) -> void:
	want_look_angle = Input.get_axis(INPUT_LOOK_UP, INPUT_LOOK_DOWN)

	want_attack_once_flag = Input.is_action_just_pressed(INPUT_ATTACK)
	want_attack_keep_flag = Input.is_action_pressed(INPUT_ATTACK)

	want_block_keep_flag = Input.is_action_pressed(INPUT_BLOCK)

	dodge_delay_timer.add_time(delta)

	state_machine.tick_frame(delta)

func _physics_process(delta: float) -> void:
	# want
	want_move_direction = Input.get_axis(INPUT_MOVE_LEFT, INPUT_MOVE_RIGHT)

	want_jump_once_flag = Input.is_action_just_pressed(INPUT_JUMP)
	want_jump_higher_flag = Input.is_action_pressed(INPUT_JUMP)
	# if Input.is_action_just_released(INPUT_JUMP):
	# 	want_jump_once_flag = false
	# 	want_jump_higher_flag = false
	# print(Engine.get_physics_frames(), ": want jump %s %s" % [want_jump_once_flag, want_jump_higher_flag])
	
	# update
	state_machine.update_state()
	# tick
	state_machine.tick_physics(delta)

	move_and_slide()

#region movement_data

func run_speed() -> float:
	return movement_data.run_speed

func run_resistance() -> float:
	return movement_data.run_resistance

func run_acceleration() -> float:
	return movement_data.run_acceleration

func air_speed() -> float:
	return movement_data.air_speed

func air_resistance() -> float:
	return movement_data.air_resistance

func air_acceleration() -> float:
	return movement_data.air_acceleration

func dodge_velocity() -> float:
	return movement_data.dodge_velocity

func dodge_acceleration() -> float:
	return movement_data.dodge_acceleration

func dodge_fast_velocity() -> float:
	return movement_data.dodge_fast_velocity

func dodge_fast_acceleration() -> float:
	return movement_data.dodge_fast_acceleration

func jump_velocity() -> float:
	return movement_data.jump_velocity

func fall_velocity() -> float:
	return movement_data.fall_velocity

func fall_gravity_scale() -> float:
	return movement_data.fall_gravity_scale

func jump_higher_gravity_scale() -> float:
	return movement_data.jump_higher_gravity_scale

func jump_higher_time_value() -> float:
	return movement_data.jump_higher_time_value

func double_jump_value() -> int:
	return movement_data.double_jump_value

func fly_velocity_min() -> float:
	return movement_data.fly_velocity_min

func fly_velocity_max() -> float:
	return movement_data.fly_velocity_max

func climb_velocity() -> float:
	return movement_data.climb_velocity

func climb_gravity_scale() -> float:
	return movement_data.climb_gravity_scale

#endregion

#region wants

func want_look() -> bool:
	return not is_zero_approx(want_look_angle)

func want_move() -> bool:
	return not is_zero_approx(want_move_direction)

func make_want_jump() -> void:
	# 修改意图 让下个状态进行跳跃 有点魔法的感觉 可能会导致BUG
	# 状态退出后 上下文修改 应该要重新进行状态条件的判断 否则进入逻辑会与预期不一致
	# 或者人为约定 状态的进入条件必须是客观条件 没有主观意愿（当前选择这个）
	print("make_want_jump!!!")
	want_jump_higher_flag = true
	want_jump_once_flag = true

func want_jump_once() -> bool:
	return want_jump_once_flag

func want_jump_higher() -> bool:
	return want_jump_higher_flag

func want_dodge() -> bool:
	return dodge_delay_timer.in_time()

func echo_dodge():
	dodge_delay_timer.final_time()

func want_attack_once() -> bool:
	return want_attack_once_flag

func want_attack_keep() -> bool:
	return want_attack_keep_flag

func want_block_keep() -> bool:
	return want_block_keep_flag

#endregion

#region can

func hand_on_wall() -> bool:
	return hand_line.is_colliding()

func foot_on_wall() -> bool:
	return foot_line.is_colliding()

#endregion

#region do_effects

func do_dodge(delta: float, fast: bool) -> void:
	# 闪避时需要禁止翻转图像
	if fast:
		do_move(delta, body.scale.x * dodge_fast_velocity(), dodge_fast_acceleration())
	else:
		do_move(delta, body.scale.x * dodge_velocity(), dodge_acceleration())
	# print("do_dodge ", velocity.x)

func do_move(delta: float, speed: float, a: float) -> void:
	velocity.x = move_toward(velocity.x, speed, a * delta)

func do_fall(delta: float, speed: float, g_scale: float) -> void:
	var force := 0.0
	if velocity.y > 0:
		force += velocity.y # fall faster

	# print("%s : falling %s %s" % [Engine.get_physics_frames(), force * delta, base_gravity * g_scale * delta])
	velocity.y = move_toward(velocity.y, speed, force * delta + base_gravity * g_scale * delta)

func do_jump_normal() -> void:
	# print("%s : do_jump" % Engine.get_physics_frames())
	velocity.y = jump_velocity()

func do_jump(speed: float) -> void:
	velocity.y = speed

#endregion

#region play_animations

func play_turn() -> void:
	if want_move():
		body.scale.x = -1.0 if want_move_direction < 0 else 1.0

func play_once_anim(anim: String) -> void:
	anim_player.play_once_anim(anim)

func play_loop_anim(anim: String) -> void:
	anim_player.play_loop_anim(anim)

#endregion
