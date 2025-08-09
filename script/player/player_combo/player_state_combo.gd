class_name StateCombo
extends PlayerState

@onready var state_machine: TransitionStateMachine = $TransitionStateMachine

func in_perfect_block() -> bool:
	return state_machine.current_state is StateComboBlock and (state_machine.current_state as StateComboBlock).in_perfect_block()

func will_enter() -> bool:
	# 内部类 永远不进入 由拥有者自己决定何时调用
	return false

func on_enter() -> void:
	# 内部类 不执行父类的方法
	pass

func tick_frame(delta: float) -> void:
	state_machine.tick_frame(delta)
