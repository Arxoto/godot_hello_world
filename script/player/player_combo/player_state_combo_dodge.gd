class_name StateComboDodge
extends StateComboSuper

const STATE_NAME = "dodge"

func _ready() -> void:
	super._ready()
	register(STATE_NAME, self)

func on_enter() -> void:
	super.on_enter()
	character.anim_player.play_once_anim(character.anim_player.anim_dodge)

# 原规划是要在“动作状态”（攀爬、空中、地面）里各自实现闪避/冲刺的，因为涉及物理系统
# 但是为了保证逻辑与格挡一致（帧判断完美闪避），逻辑放在“战斗动画”（连段）里，并通过特定属性在“动作状态”里各自实现
