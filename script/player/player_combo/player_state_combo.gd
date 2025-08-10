class_name StateCombo
extends Node

@onready var state_machine: TransitionStateMachine = $TransitionStateMachine

# 导出变量，由动画控制，代码中只读（除初始化）

@export var can_move := true
@export var can_jump := true
@export var can_dodge := true
@export var can_block := true
@export var can_attack := true
@export var can_block_attack := false
@export var can_attack_twice := false
@export var can_heavy_attack := false
@export var perfect_dodge_flag := false
@export var perfect_block_flag := false
@export var block_attack_flag := false

func set_can_block_attack(v):
	can_block_attack = v

func reset_controller():
	can_move = true
	can_jump = true
	can_dodge = true
	can_block = true
	can_attack = true
	can_block_attack = false
	can_attack_twice = false
	can_heavy_attack = false
	perfect_dodge_flag = false
	perfect_block_flag = false
	block_attack_flag = false

func in_perfect_dodge() -> bool:
	return perfect_dodge_flag

func in_perfect_block() -> bool:
	return state_machine.current_state is StateComboBlock and perfect_block_flag

func in_block_attack() -> bool:
	return state_machine.current_state is StateComboBlockAttack and block_attack_flag

func tick_frame(delta: float) -> void:
	state_machine.tick_frame(delta)
