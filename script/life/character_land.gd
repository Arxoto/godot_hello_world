class_name CharacterLand
extends CharacterBody2D

## 重力加速度
var base_gravity := ProjectSettings.get("physics/2d/default_gravity") as float

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var graphics: Node2D = $Graphics
@onready var look_for_enemy: RayCast2D = $Graphics/LookForEnemy
@onready var look_front: RayCast2D = $Graphics/LookFront
@onready var look_down: RayCast2D = $Graphics/LookDown

@onready var state_machine: StateMachine = $StateMachine
@onready var idle_timer: Timer = $IdleTimer
@onready var walk_timer: Timer = $WalkTimer
@onready var angry_timer: Timer = $AngryTimer

## 下落速度
@export var fall_velocity := 800.0
## 移动速度
@export var walk_speed := 50.0
## 移动速度
@export var run_speed := 200.0
## 加速度
@export var run_accel := 800.0
## 移动方向
var run_direction := 1.0

func _ready() -> void:
	turn_around()

func _physics_process(delta: float) -> void:
	state_machine.update_state()
	state_machine.tick(delta)
	state_machine.play()

	do_fall(delta)
	move_and_slide()

func see_enemy() -> bool:
	if not look_for_enemy.is_colliding():
		return false
	
	var collider := look_for_enemy.get_collider()
	return collider != null and collider is PlayerCharacter

func do_stop(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0.0, run_accel * delta)

func do_walk(delta: float) -> void:
	velocity.x = move_toward(velocity.x, run_direction * walk_speed, run_accel * delta)

func do_run(delta: float) -> void:
	velocity.x = move_toward(velocity.x, run_direction * run_speed, run_accel * delta)

func do_fall(delta: float) -> void:
	velocity.y = move_toward(velocity.y, fall_velocity, base_gravity * delta)

func should_turn() -> bool:
	if not is_on_floor():
		return false
	if look_front.is_colliding():
		var collider := look_front.get_collider()
		return collider != null and not collider is PlayerCharacter
	if not look_down.is_colliding():
		return true
	return false

func turn_around():
	run_direction = -1.0 if run_direction > 0 else 1.0
	graphics.scale.x = -1.0 if run_direction > 0 else 1.0
