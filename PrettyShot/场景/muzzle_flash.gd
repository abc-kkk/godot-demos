extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = true
	$Timer.start(lifetime * speed_scale)

func _on_timer_timeout() -> void:
	call_deferred("queue_free")
