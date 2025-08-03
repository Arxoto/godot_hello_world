class_name PlayerState
extends ConditionStateBase

var character: PlayerCharacter

const anim_run: String = "run"
const anim_idle: String = "idle"
const anim_air_to_climb: String = "air_to_climb"
const anim_climb: String = "climb"
const anim_floor_to_jump: String = "floor_to_jump"
const anim_jump: String = "jump"
const anim_fall: String = "fall"
const anim_fall_to_floor: String = "fall_to_floor"

const loop_anims: Array[String] = [anim_run, anim_idle, anim_climb, anim_jump, anim_fall]

static var source: String
static var targte: String

func _ready() -> void:
	character = owner

func on_enter() -> void:
	targte = name
	transition()

func on_exit() -> void:
	source = name

func transition() -> void:
	# print("state transition ", source + "-" + targte)
	match source + "-" + targte:
		"InAir-OnFloor":
			play_once_anim(anim_fall_to_floor)
		"InAir-Climb":
			play_once_anim(anim_air_to_climb)

func play_once_anim(anim: String) -> void:
	character.animation_player.play(anim)

func play_loop_anim(anim: String) -> void:
	if not character.animation_player.is_playing():
		character.animation_player.play(anim)
	elif character.animation_player.current_animation in loop_anims:
		character.animation_player.play(anim)
