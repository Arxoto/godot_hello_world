class_name StateComboBlockAttack
extends StateComboSuper

const STATE_NAME = "block_attack"

func _ready() -> void:
	super._ready()
	register(STATE_NAME, self)

func on_enter() -> void:
	super.on_enter()
	character.anim_player.play_once_anim(character.anim_player.anim_block_attack)
	print("block_attack !!! todo play anim")
