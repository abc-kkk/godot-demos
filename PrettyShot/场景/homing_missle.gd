extends Area2D


@export var explosion = preload("res://场景/blood_splat.tscn")

@export var speed = 500

var velocity = Vector2.RIGHT * speed # 初始速度向右
var target = null
var steer_force = 40.0
var acceleration = Vector2.ZERO

var inside_destruction = []

func _ready() -> void:
	# 一个随机的角度
#	rotation_degrees += randi_range(-35, 35)
	velocity = transform.x * speed 
	
func _physics_process(delta: float) -> void:
	if !target:  # 这里有可能出现目标已经死亡被free的情况
		seek()
		return
	var to_target
	# 计算指向目标的单位速度向量
	if target is Vector2:
		to_target = (target - position).normalized()*speed
		seek() # 寻找一个敌人
	else:
		to_target = (target.global_position - position).normalized()*speed
	to_target = (to_target - velocity).normalized() * steer_force
	acceleration += to_target
	velocity += acceleration * delta
	rotation = velocity.angle()
	position += velocity * delta
	
func seek():
	var nearest_dist = INF 
	var nearest_enemy
	# 寻找最近敌人
	for enemy in get_parent().get_node("Enemies").get_children():
		var dist = global_position.distance_to(enemy.global_position)
		if dist < nearest_dist:
			nearest_enemy = enemy
	if nearest_enemy:
		target = nearest_enemy
	else:
		target = get_global_mouse_position()
	
func die():
	for x in inside_destruction:
		if !x.has_method("die"): continue
		var instance = explosion.instantiate()
		instance.global_position = global_position
		get_parent().call_deferred("add_child", instance)
		x.die()
	call_deferred("queue_free")

func _on_body_entered(body: Node2D) -> void:
	inside_destruction.append(body)
	die()


func _on_timer_timeout() -> void:
	die()


func _on_destruction_body_entered(body: Node2D) -> void:
	inside_destruction.append(body)


func _on_destruction_body_exited(body: Node2D) -> void:
	inside_destruction.erase(body)
