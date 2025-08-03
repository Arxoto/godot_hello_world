class_name StateLandAir
extends StateLand

const STATE_NAME = "air"

func _ready():
	super._ready()
	register(STATE_NAME)

func tick_physics(delta: float) -> TransitionStateBase:
	if character.is_on_floor():
		return state(StateLandIdle.STATE_NAME)
	
	character.do_stop(delta)
	character.animation_player.play("walk")
	return null
