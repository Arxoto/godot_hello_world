class_name LandTurn
extends StateLand

func will_enter() -> bool:
	return character.should_turn()

func tick(delta: float) -> void:
	character.do_stop(delta)
	character.turn_around()

func play():
	pass
