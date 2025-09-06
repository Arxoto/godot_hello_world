class_name Hurtbox
extends Area2D

var combat_entity: CombatEntity

func _init():
	monitoring = false
	monitorable = true
	collision_layer = 0
	collision_mask = 0
	set_collision_layer_value(4, true)
