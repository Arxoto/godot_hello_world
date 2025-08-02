class_name LandRun
extends StateLand

func will_enter() -> bool:
	if character.see_enemy():
		character.angry_timer.start()
		return true
	return not character.angry_timer.is_stopped()

func tick(delta: float) -> void:
	character.do_run(delta)
	character.animation_player.play("run")
