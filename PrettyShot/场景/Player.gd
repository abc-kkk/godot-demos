extends CharacterBody2D

@onready var player: Sprite2D = $Sprite2D
@onready var mark: Marker2D = $Marker2D
@onready var shoot_interval: Timer = $Timer
@onready var camera_2d: Camera2D = $Camera2D
@onready var rokect_shoot: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var muzzle_flash: PackedScene = preload("res://场景/muzzle_flash.tscn")
@export var bullet = preload("res://场景/bullet.tscn")
@export var missile = preload("res://场景/homing_missle.tscn")

var can_shoot = true
var accel = 0.1
var deccel = 0.25
var rotation_speed = 0.2

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	var mos_pos = get_global_mouse_position()
	camera_2d.offset = Vector2((mos_pos.x - global_position.x) / 10.0 ,(mos_pos.y - global_position.y) / 5.0)
	var dir = (mos_pos - global_position).normalized()
	var angle = dir.angle()
	global_rotation = lerp_angle( global_rotation,angle,rotation_speed )
#	look_at(mos_pos)
#	返回一个介于 0 和 1 之间的值，表示给定动作的强度。例如，在游戏手柄中，轴（模拟摇杆或 L2、R2 触发器）离死区越远，该值将越接近 1。如果动作被映射到一个如键盘一样没有轴的控制器时，返回值将为 0 或 1。
	var dir_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var dir_y = Input.get_action_strength("down") - Input.get_action_strength("up")
	if dir_x != 0 or dir_y != 0:
		velocity.y = lerp(velocity.y,dir_y*SPEED,accel)
		velocity.x = lerp(velocity.x,dir_x*SPEED,accel)
	else:
		velocity.y = lerp(velocity.y,0.0,accel)
		velocity.x = lerp(velocity.x,0.0,accel)
#	velocity = velocity.clamp(Vector2.ZERO,velocity*SPEED)
	move_and_slide()
	var collision_count = get_slide_collision_count()
	for i in collision_count:
		var collision = get_slide_collision(i)
		camera_2d.shake(0.2, 25, 5)
	
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot_interval.start(0.2)
		can_shoot = false
		camera_2d.shake(0.25,25,8)
		var _dir = (mos_pos - mark.global_position).normalized()
		var inst = muzzle_flash.instantiate()
		inst.position = $MuzzleMark.position
		call_deferred("add_child", inst)
		
		var bt = bullet.instantiate()
		bt.shoot(_dir,mark.global_position)
		get_parent().call_deferred("add_child",bt)
	if Input.is_action_pressed("shoot_missile") and can_shoot:
		rokect_shoot.stop()
		rokect_shoot.play()
		shoot_interval.start(0.4)
		can_shoot = false
		camera_2d.shake(0.3,30,12)
		var _dir = (mos_pos - mark.global_position).normalized()
		var inst = muzzle_flash.instantiate()
		inst.position = $MuzzleMark.position
		call_deferred("add_child", inst)
		
		var instance = missile.instantiate()
		instance.global_transform = mark.global_transform
		
		var nearest_dist = INF 
		var nearest_enemy
		# 寻找最近敌人
		for enemy in get_parent().get_node("Enemies").get_children():
			var dist = mark.global_position.distance_to(enemy.global_position)
			if dist < nearest_dist:
				nearest_enemy = enemy
		if nearest_enemy:
			instance.target = nearest_enemy
		else:
			instance.target = get_global_mouse_position()
		get_parent().call_deferred("add_child", instance)
		
	
func _on_timer_timeout() -> void:
	can_shoot = true
	
	
	
	
	
	
	
	
	
