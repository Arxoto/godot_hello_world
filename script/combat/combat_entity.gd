class_name CombatEntity
extends Node

var combat_state := CombatState.NROMAL
var shield_state := ShieldState.NO_SHIELD

## 受击 struck
signal hit(state: CombatState)

## 渲染图像 用于获取受击和命中判定框
@export var graphics: Node2D
var hitboxs: Array[Hitbox] = []
var hurtboxs: Array[Hurtbox] = []

@onready var combat_unit: CombatUnit = $"../CombatUnit"

func _ready():
	for node in graphics.get_children():
		if node is Hitbox:
			hitboxs.append(node)
		elif node is Hurtbox:
			hurtboxs.append(node)
	
	for hitbox in hitboxs:
		hitbox.hit.connect(self.on_hit_hurt)
		hitbox.combat_entity = self
	for hurtbox in hurtboxs:
		hurtbox.combat_entity = self

var test_time := 0.0
var test_last := 0
func _process(delta):
	if owner.name == "Player":
		#var tmp_value = combat_unit.health.get_current()
		var tmp_value = combat_unit.stamina.get_current()
		test_time += delta
		if int(test_time) != test_last:
			test_last = int(test_time)
			print("player value %s %s" % [test_time, tmp_value])
	return

func on_hit_hurt(hitbox: Hitbox, hurtbox: Hurtbox):
	print("[Hit] from %s:%s to %s:%s" % [hitbox.owner.name, hitbox.name, hurtbox.owner.name, hurtbox.name])
	
	# 扣血 测试回复
	#hurtbox.combat_entity.combat_unit.health.use_inst_effect(ExPropInstEffect.create_val(hitbox.owner.name, EffectNames.PHYSICS_DAMAGE, -20.0))
	
	# 加连贯值 测试延迟扣除 需要重置效果时间
	hurtbox.combat_entity.combat_unit.stamina.use_inst_effect(ExPropInstEffect.create_val(hitbox.owner.name, EffectNames.PHYSICS_DAMAGE, 50.0))
	hurtbox.combat_entity.combat_unit.stamina.restart_period_effect(ExPropPeriodEffect.create_inf_val(hitbox.owner.name, EffectNames.STAMINA_DECLINE, 0.0, 0.0))

	match hurtbox.combat_entity.combat_state:
		CombatState.NROMAL:
			pass
		CombatState.DODGE_PERFECT:
			pass
		CombatState.BLOCK_NO_SHIELD:
			pass
		CombatState.BLOCK_HAS_SHIELD:
			pass
		CombatState.BLOCK_PERFECT_NO_SHIELD:
			pass
		CombatState.BLOCK_PERFECT_HAS_SHIELD:
			pass
		CombatState.BLOCK_ATTACK_NO_SHIELD:
			pass
		CombatState.BLOCK_ATTACK_HAS_SHIELD:
			pass
		CombatState.BLOCK_ATTACK_HUGE_SHIELD:
			pass
		_:
			push_error("[Hit_Not_Impl] from %s:%s to %s:%s" % [hitbox.owner.name, hitbox.name, hurtbox.owner.name, hurtbox.name])

#region state_define

enum ActionState {
	NROMAL,
	DODGE_PERFECT,
	BLOCK,
	BLOCK_PERFECT,
	BLOCK_ATTACK,
}

enum ShieldState {
	NO_SHIELD,
	HAS_SHIELD,
	HUGE_SHIELD,
}

enum CombatState {
	## 一般
	NROMAL,
	## 完美闪避
	DODGE_PERFECT,

	## 防御 无盾
	BLOCK_NO_SHIELD,
	## 防御 有盾
	BLOCK_HAS_SHIELD,

	## 招架 完美防御-无盾
	BLOCK_PERFECT_NO_SHIELD,
	## 格挡 完美防御-有盾
	BLOCK_PERFECT_HAS_SHIELD,

	## 拼刀 弹反-无盾
	BLOCK_ATTACK_NO_SHIELD,
	## 盾反 弹反-有盾
	BLOCK_ATTACK_HAS_SHIELD,
	## 盾击 弹反-有盾
	BLOCK_ATTACK_HUGE_SHIELD,
}

func set_combat_state(action_state: ActionState):
	if action_state == ActionState.NROMAL: combat_state = CombatState.NROMAL
	elif action_state == ActionState.DODGE_PERFECT: combat_state = CombatState.DODGE_PERFECT

	elif action_state == ActionState.BLOCK and shield_state == ShieldState.NO_SHIELD: combat_state = CombatState.BLOCK_NO_SHIELD
	elif action_state == ActionState.BLOCK and shield_state != ShieldState.NO_SHIELD: combat_state = CombatState.BLOCK_HAS_SHIELD

	elif action_state == ActionState.BLOCK_PERFECT and shield_state == ShieldState.NO_SHIELD: combat_state = CombatState.BLOCK_PERFECT_NO_SHIELD
	elif action_state == ActionState.BLOCK_PERFECT and shield_state != ShieldState.NO_SHIELD: combat_state = CombatState.BLOCK_PERFECT_HAS_SHIELD

	elif action_state == ActionState.BLOCK_ATTACK and shield_state == ShieldState.NO_SHIELD: combat_state = CombatState.BLOCK_ATTACK_NO_SHIELD
	elif action_state == ActionState.BLOCK_ATTACK and shield_state == ShieldState.HAS_SHIELD: combat_state = CombatState.BLOCK_ATTACK_HAS_SHIELD
	elif action_state == ActionState.BLOCK_ATTACK and shield_state == ShieldState.HUGE_SHIELD: combat_state = CombatState.BLOCK_ATTACK_HUGE_SHIELD

	else: push_error("unknown stata: %s %s" % [action_state, shield_state])

#endregion
