class_name RaceData
extends Resource

## 升级所需的经验公式 exp = exp_mult * exp_base ^ level
var exp_mult := 100
## 升级所需的经验公式 exp = exp_mult * exp_base ^ level
var exp_base := 2

## 升级所需的经验值（若有值则优先）
var exp_needs: Array[int]

## 等级上限
var max_level := 10
## 每级自由点数
var free_points := 1

## 气力基础值
var strength_base := 100.0
## 每点气力成长值
var strength_scale := 10.0
## 每级气力成长加点
var strength_points := 1

## 信念基础值
var belief_base := 100.0
## 每点信念成长值
var belief_scale := 10.0
## 每级信念成长加点
var belief_points := 1

## 血量基础值
var health_base := 100.0
## 血量成长值（根据气力）
var health_scale := 0.3
## 每秒回复最大血量的 1%
var health_recover_ratio := 0.01
## 每秒回复 0.5
var health_recover_value := 0.5
# todo 血量回复效果 百分比和定值分别实现

## 连贯 最大值
var stamina_max := 100.0

## 气势最大值 基础值
var magicka_max_base := 100.0
## 气势最大值 成长值（根据信念）
var magicka_max_scale := 0.2
## 气势趋向值 基础值
var magicka_target_base := 30.0

## 返回下一等级所需经验 零和负数表示无法升级
func need_exp(level: int) -> int:
	if level >= max_level:
		return -1
	
	if exp_needs.size() > level:
		return exp_needs.get(level)
	else:
		return exp_mult * exp_base ** level
