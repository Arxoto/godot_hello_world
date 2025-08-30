class_name LevelUp
extends RefCounted

# 展示时加一
var level := 0
var experience := 0

var free_points := 0

var strength_points := 0
var belief_points := 0

func init_race(race_data: RaceData):
	level = 0
	experience = 0
	free_points = race_data.free_points
	strength_points = race_data.strength_points
	belief_points = race_data.belief_points

func level_up(need_exp: int, race_data: RaceData):
	level += 1
	experience -= need_exp
	free_points += race_data.free_points
	strength_points += race_data.strength_points
	belief_points += race_data.belief_points

## 计算升级 返回是否成功升级
func try_level_up(race_data: RaceData) -> bool:
	var upped := false
	while true:
		var need_exp := race_data.need_exp(level)
		if need_exp <= 0:
			break
		level_up(need_exp, race_data)
		upped = true
	
	return upped

## 增加经验 返回是否成功升级
func add_exp(expe: int, race_data: RaceData) -> bool:
	experience += expe
	return try_level_up(race_data)
