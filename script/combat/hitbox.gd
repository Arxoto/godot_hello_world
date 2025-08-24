class_name Hitbox
extends Area2D

signal hit(hitbox, hurtbox)

var combat_unit: CombatUnit

func _init():
	monitoring = true
	monitorable = false
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(4, true)

	area_entered.connect(on_area_entered)

func on_area_entered(hurtbox: Area2D):
	if self.owner == hurtbox.owner:
		return
	hit.emit(self, hurtbox)
