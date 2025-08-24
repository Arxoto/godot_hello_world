class_name PlayerMovementData
extends Resource

## 地面上的移动速度
@export var run_speed := 200.0
## 地面上的摩擦力，若为操作手感可缩短； 0.05s 停止
@export var run_resistance := 4000.0
## 地面上的加速度； 0.1s 达到最高速， 0.2s 转身
@export var run_acceleration := 2000.0

## 空中的移动速度
@export var air_speed := 200.0
## 空中的摩擦力较小，可适当缩短若提升操作手感，保证落点可控； 0.125s 停止
@export var air_resistance := 1600.0
## 空中更不灵活； 0.125s 达到最高速， 0.25s 转身
@export var air_acceleration := 1600.0

## 闪避/冲刺/翻滚速度
@export var dodge_velocity := 200.0
## 闪避/冲刺/翻滚加速度
@export var dodge_acceleration := 3000.0
## 闪避/冲刺/翻滚速度（分段速度）
@export var dodge_fast_velocity := 300.0
## 闪避/冲刺/翻滚加速度（分段速度）
@export var dodge_fast_acceleration := 6000.0

## 起跳速度；控制跳跃最低高度为一格
@export var jump_velocity := -200.0
## 下落最大速度
@export var fall_velocity := 500.0
## 正常的下落加速度
@export var fall_gravity_scale := 1.0
## 跳高时的下落加速度；负数会导致跳跃曲线异样；控制跳跃最高高度恰好为三格
@export var jump_higher_gravity_scale := 0.2
## 跳高的时长；过长会导致浮空感；控制跳跃最高高度恰好为三格
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
