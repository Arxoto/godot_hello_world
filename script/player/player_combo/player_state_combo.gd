class_name StateCombo
extends Node

@onready var state_machine: TransitionStateMachine = $TransitionStateMachine

# 导出变量，由动画控制，代码中只读（除初始化）

@export var can_turn: bool
@export var can_move: bool
@export var can_jump: bool
@export var can_jump_higher: bool
@export var can_dodge: bool
@export var can_block: bool
@export var can_attack: bool
@export var can_block_attack: bool
@export var can_attack_twice: bool
@export var can_heavy_attack: bool

@export var do_dodge: bool
@export var do_fast_dodge: bool

@export var perfect_dodge_flag: bool
@export var perfect_block_flag: bool
@export var block_attack_flag: bool

func reset_controller():
	can_turn = true
	can_move = true
	can_jump = true
	can_jump_higher = true
	can_dodge = true
	can_block = true
	can_attack = true
	can_block_attack = false
	can_attack_twice = false
	can_heavy_attack = false

	do_dodge = false
	do_fast_dodge = false
	
	perfect_dodge_flag = false
	perfect_block_flag = false
	block_attack_flag = false

func _ready():
	reset_controller()

func in_perfect_dodge() -> bool:
	return state_machine.current_state is StateComboDodge and perfect_dodge_flag

func in_perfect_block() -> bool:
	return state_machine.current_state is StateComboBlock and perfect_block_flag

func in_block_attack() -> bool:
	return state_machine.current_state is StateComboBlockAttack and block_attack_flag

func tick_frame(delta: float) -> void:
	state_machine.tick_frame(delta)
