extends Node2D

@onready var tile_map: TileMap = $TileMap
@onready var enemy_genery_timer: Timer = $Timer
@onready var enemies: Node2D = $Enemies

var r_p: Vector2i = Vector2i.ZERO
var enemy = preload("res://场景/Enemy.tscn")
# 每秒随机出现3个敌人 

func _ready() -> void:
	enemy_genery_timer.start(1)

func _process(delta: float) -> void:
	pass

func start_general():
	general_enemy()

func general_enemy():
	var en = enemy.instantiate()
	randi_point()
#	print("this is " + str(r_p))
	en.position = tile_map.map_to_local(r_p)
	enemies.add_child(en)

func randi_point():
	r_p = Vector2i( randi_range(-5,40),randi_range(-3,28))
	var tile_data = tile_map.get_cell_tile_data(0,r_p)
	if tile_data:
		var is_can_general = tile_data.get_custom_data("can_general")
		if !is_can_general:
			randi_point()
		else:
			pass
	else: 
		randi_point()

func _on_timer_timeout() -> void:
	start_general()
