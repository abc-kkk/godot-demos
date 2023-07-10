extends Area2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var acceleration = 400
var dir = Vector2.ZERO

func _ready() -> void:
	audio_stream_player_2d.play()
	
func _physics_process(delta: float) -> void:
	position += acceleration * delta * dir

func shoot(_dir , pos):
	global_position = pos
	dir = _dir 
	rotation = dir.angle()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.die()
	call_deferred("queue_free")
