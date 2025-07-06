class_name StateOnFloor
extends StateCharacter

func will_enter() -> bool:
	return character.is_on_floor()

func tick(delta: float) -> void:
	if character.want_jump_once():
		character.do_jump_normal()
	
	if character.want_move():
		character.do_move(delta, character.want_move_direction * character.run_speed(), character.run_acceleration())
	else:
		character.do_move(delta, 0, character.run_resistance())

func play() -> void:
	character.play_turn()
	if not is_zero_approx(character.velocity.x):
		character.animation_player.play("running")
	else:
		character.animation_player.play("idle")
