class_name PlayerCharacter
extends CharacterBody2D

## 重力加速度
var base_gravity := ProjectSettings.get("physics/2d/default_gravity") as float

@onready var body: Node2D = $TheBody
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var hand_line: RayCast2D = $TheBody/HandLine
@onready var foot_line: RayCast2D = $TheBody/FootLine

@export var movement_data: PlayerMovementData

## 仅有激活（摁住）和释放（不摁）状态，不涉及摁下和抬起
var want_look_angle: float
## 仅有激活（摁住）和释放（不摁）状态，不涉及摁下和抬起
var want_move_direction: float
## 摁下直到抬起视为一次跳跃
var want_jump_once_flag := false
## 激活向上加速，释放减速
var want_jump_higher_flag := false

func _process(_delta: float) -> void:
	want_look_angle = Input.get_axis("look_up", "look_down")

func _physics_process(delta: float) -> void:
	# want
	want_move_direction = Input.get_axis("move_left", "move_right")
	want_jump_once_flag = Input.is_action_just_pressed("jump")
	want_jump_higher_flag = Input.is_action_pressed("jump")
	if Input.is_action_just_released("jump"):
		want_jump_once_flag = false
		want_jump_higher_flag = false
	# print(Engine.get_physics_frames(), ": want jump %s %s" % [want_jump_once_flag, want_jump_higher_flag])
	# update
	state_machine.update_state()
	# tick
	state_machine.tick(delta)
	# play
	state_machine.play()

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

func jump_velocity() -> float:
	return movement_data.jump_velocity

func fall_velocity() -> float:
	return movement_data.fall_velocity

func fall_gravity_scale() -> float:
	return movement_data.fall_gravity_scale

func jump_gravity_scale() -> float:
	return movement_data.jump_gravity_scale

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
	want_jump_higher_flag = true
	want_jump_once_flag = true

func want_jump_once() -> bool:
	return want_jump_once_flag

func want_jump_higher() -> bool:
	return want_jump_higher_flag

#endregion

#region can

func hand_on_wall() -> bool:
	return hand_line.is_colliding()

func foot_on_wall() -> bool:
	return foot_line.is_colliding()

#endregion

#region do_effects

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

#endregion
