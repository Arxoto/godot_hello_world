class_name StateLandRun
extends StateLandFloor

const STATE_NAME = "run"

func _ready():
	super._ready()
	register(STATE_NAME, self)

func on_enter() -> void:
	character.angry_timer.start()

func tick_physics(delta: float) -> TransitionStateBase:
	var s = super.tick_physics(delta)
	if s:
		return s
	
	if character.see_enemy():
		character.angry_timer.start()
	if character.angry_timer.is_stopped():
		return state(StateLandIdle.STATE_NAME)
	
	if character.should_turn():
		character.do_stop(delta)
		character.turn_around()
	else:
		character.do_run(delta)
	character.animation_player.play("run")
	
	return null
