extends CharacterBody2D

const SPEED = 80.0

@onready var nav_agent = $NavigationAgent2D
@export var blood = preload("res://场景/blood_splat.tscn")


func _physics_process(delta):
	var dir = get_nav_position()
	velocity = dir * SPEED
	move_and_slide()

func get_nav_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if !player:
		return
	nav_agent.target_position = player.global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	look_at(next_path_position)
	return (next_path_position - position).normalized()


func die():
	var ins = blood.instantiate()
	ins.global_transform = global_transform
	get_parent().call_deferred("add_child",ins)
	call_deferred("queue_free")
	
	
