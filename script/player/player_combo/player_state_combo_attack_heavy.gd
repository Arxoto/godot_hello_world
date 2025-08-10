class_name StateComboAttackHeavy
extends StateComboSuper

const STATE_NAME = "attack_heavy"

func _ready() -> void:
	super._ready()
	register(STATE_NAME, self)

func on_enter() -> void:
	super.on_enter()
	character.anim_player.play_once_anim(character.anim_player.anim_attack_3)
