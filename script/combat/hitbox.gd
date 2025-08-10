class_name Hitbox
extends Area2D

signal hit(hurtbox)

func _init():
	monitoring = true
	monitorable = false
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(4, true)

	area_entered.connect(on_area_entered)

func on_area_entered(hurtbox: Hurtbox):
	if self.owner == hurtbox.owner:
		return
	print("[Hit] from %s to %s" % [self.owner.name, hurtbox.owner.name])
	hit.emit(hurtbox)
	hurtbox.hurt.emit(self)
