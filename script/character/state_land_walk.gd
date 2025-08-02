class_name LandWalk
extends StateLand

var idle := false

func start_walk():
	idle = false
	character.walk_timer.start()
	character.idle_timer.stop()

func start_idle():
	idle = true
	character.walk_timer.stop()
	character.idle_timer.start()

func will_enter() -> bool:
	return true

func tick(delta: float) -> void:
	if idle:
		if character.idle_timer.is_stopped():
			start_walk()
	else:
		if character.walk_timer.is_stopped():
			start_idle()

	if idle:
		character.do_stop(delta)
		character.animation_player.play("idle")
	else:
		character.do_walk(delta)
		character.animation_player.play("walk")
