class_name RaceData
extends Resource

## 升级所需的经验公式 exp = exp_mult * exp_base ^ level
@export var exp_mult := 100
## 升级所需的经验公式 exp = exp_mult * exp_base ^ level
@export var exp_base := 2

## 升级所需的经验值（若有值则优先）
@export var exp_needs: Array[int]

## 等级上限
@export var max_level := 10
## 每级自由点数
@export var free_points := 1

## 气力基础值
@export var strength_base := 100.0
## 每点气力成长值
@export var strength_scale := 10.0
## 每级气力成长加点
@export var strength_points := 1

## 信念基础值
@export var belief_base := 100.0
## 每点信念成长值
@export var belief_scale := 10.0
## 每级信念成长加点
@export var belief_points := 1

## 血量基础值
@export var health_base := 100.0
## 血量成长值（根据气力）
@export var health_scale := 0.3
## 血量 每次回复间隔时间
@export var health_recover_period := 1.0
## 血量 每次回复上限的 1%
@export var health_recover_ratio := 0.01
## 血量 每次回复 0.5
@export var health_recover_value := 0.5

## 连贯最大值
@export var stamina_max := 100.0
## 连贯 下降的延迟时间
@export var stamina_wait := 3.0
## 连贯 下降的间隔时间 2s清空
@export var stamina_period := 0.1
## 连贯 下降的值 2s清空
@export var stamina_decline_value := -5.0

## 气势最大值 基础值
@export var magicka_max_base := 100.0
## 气势最大值 成长值（根据信念）
@export var magicka_max_scale := 0.2
## 气势 本我趋向值
@export var magicka_target_self := 30.0
## 气势 趋向的间隔时间 todo耗时待确认
@export var magicka_target_period := 0.2
## 气势 本我趋向的速度 todo耗时待确认
@export var magicka_target_self_stack := 3
## 气势 外界趋向的速度 todo耗时待确认
@export var magicka_target_env_stack := 2

## 返回下一等级所需经验 零和负数表示无法升级
func need_exp(level: int) -> int:
	if level >= max_level:
		return -1
	
	if exp_needs.size() > level:
		return exp_needs.get(level)
	else:
		return exp_mult * exp_base ** level
