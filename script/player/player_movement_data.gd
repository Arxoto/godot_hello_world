class_name PlayerMovementData
extends Resource

## 地面上的移动速度
@export var run_speed := 200.0
## 地面上的摩擦力
@export var run_resistance := 800.0 # 0.25s 停止
## 地面上的加速度
@export var run_acceleration := 1600.0 # 0.25s 转身 视觉效果相对更明显

## 空中的移动速度
@export var air_speed := 200.0
## 空中的摩擦力 一般认为速度保持得更久
@export var air_resistance := 200.0
## 空中的加速度 一般认为更灵活
@export var air_acceleration := 2000.0

## 起跳速度
@export var jump_velocity := -200.0
## 下落最大速度
@export var fall_velocity := 500.0
## 正常的下落加速度
@export var fall_gravity_scale := 1.0
## 跳高时的下落加速度
@export var jump_higher_gravity_scale := 0.1
## 跳高的时长
@export var jump_higher_time_value := 0.2
## 二段跳次数
@export var double_jump_value := 1

## 起飞的最小速度
@export var fly_velocity_min := -100.0
## 起飞的最大速度
@export var fly_velocity_max := -550.0

## 攀爬时向下滑行的速度
@export var climb_velocity := 80.0
## 攀爬时摩擦力较大 因此认为向下加速度更大
@export var climb_gravity_scale := 100.0
