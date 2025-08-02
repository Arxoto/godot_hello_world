class_name PlayerState
extends ConditionStateBase

var character: PlayerCharacter

func _ready() -> void:
	character = owner
