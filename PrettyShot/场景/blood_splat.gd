extends CPUParticles2D


func _ready() -> void:
	$Timer.start(lifetime * speed_scale)
	emitting = true
	$boomb.emitting = true

func _on_timer_timeout() -> void:
	call_deferred("queue_free")
