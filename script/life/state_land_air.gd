class_name LandAir
extends StateLand

func will_enter() -> bool:
	return not character.is_on_floor()

func tick(delta: float) -> void:
	character.do_stop(delta)

func play():
	character.animation_player.play("walk")
