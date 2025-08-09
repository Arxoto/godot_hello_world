class_name PlayerAnimPlayer
extends Node

@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"

const anim_run: String = "run"
const anim_idle: String = "idle"
const anim_air_to_climb: String = "air_to_climb"
const anim_climb: String = "climb"
const anim_floor_to_jump: String = "floor_to_jump"
const anim_jump: String = "jump"
const anim_fall: String = "fall"
const anim_fall_to_floor: String = "fall_to_floor"

const anim_attack_1 := "attack_1"
const anim_attack_2 := "attack_2"
const anim_attack_3 := "attack_3"
const anim_block_0 := "block_0"
const anim_block_1 := "block_1"

# const loop_anims: Array[String] = [anim_run, anim_idle, anim_climb, anim_jump, anim_fall, anim_block_1] # 目的是让循环动画的优先级最低 用下面的优先级等级代替
const combo_anims: Array[String] = [anim_attack_1, anim_attack_2, anim_attack_3, anim_block_0, anim_block_1] # 用 Dictionary 实现 "HashSet" 可能更好
const anim_priority: Dictionary[String, int] = {
	"": - 1,
	anim_run: 0,
	anim_idle: 0,
	anim_air_to_climb: 1,
	anim_climb: 0,
	anim_floor_to_jump: 1,
	anim_jump: 0,
	anim_fall: 0,
	anim_fall_to_floor: 1,
	anim_attack_1: 99,
	anim_attack_2: 99,
	anim_attack_3: 99,
	anim_block_0: 99,
	anim_block_1: 1,
}

var current_anim: String

func not_combo() -> bool:
	return anim_player.current_animation not in combo_anims

func play_once_anim(anim: String):
	play(anim)

func play_loop_anim(anim: String):
	try_play(anim)

func stop_anim():
	current_anim = "" # 仅逻辑上停止 视觉上不停止

func try_play(anim: String):
	if not anim_player.is_playing():
		play(anim)
		return
	if current_anim == anim:
		return
	if anim_priority.get(anim, 0) >= anim_priority.get(current_anim, 0):
		# print("play anim by anim_priority: ", anim)
		play(anim)

func play(anim: String):
	# print("play anim: ", anim)
	current_anim = anim
	anim_player.play(anim)
