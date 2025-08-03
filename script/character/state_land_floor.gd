class_name StateLandFloor
extends StateLand

func tick_physics(_delta: float) -> TransitionStateBase:
	if not character.is_on_floor():
		return state(StateLandAir.STATE_NAME)
	return null
