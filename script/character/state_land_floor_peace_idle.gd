class_name StateLandIdle
extends StateLandPeace

const STATE_NAME = "idle"

func _ready():
	super._ready()
	register(STATE_NAME, self)

func on_enter() -> void:
	character.idle_timer.start()

func tick_physics(delta: float) -> TransitionStateBase:
	var s = super.tick_physics(delta)
	if s:
		return s
	
	if character.idle_timer.is_stopped():
		return state(StateLandWalk.STATE_NAME)
	
	character.do_stop(delta)
	character.animation_player.play("idle")
	return null
