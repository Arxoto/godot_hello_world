class_name StateLandWalk
extends StateLandPeace

const STATE_NAME = "walk"

func _ready():
	super._ready()
	register(STATE_NAME)

func on_enter() -> void:
	character.walk_timer.start()

func tick_physics(delta: float) -> TransitionStateBase:
	var s = super.tick_physics(delta)
	if s:
		return s
	
	if character.walk_timer.is_stopped():
		return state(StateLandIdle.STATE_NAME)
	
	if character.should_turn():
		character.do_stop(delta)
		character.turn_around()
	else:
		character.do_walk(delta)
	character.animation_player.play("walk")

	return null
