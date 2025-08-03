class_name StateLandPeace
extends StateLandFloor

func tick_physics(delta: float) -> TransitionStateBase:
	var s = super.tick_physics(delta)
	if s:
		return s
	
	if character.see_enemy():
		return state(StateLandRun.STATE_NAME)
	return null
