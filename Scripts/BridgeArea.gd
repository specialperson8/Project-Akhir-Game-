extends Area2D

var phase = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if(body.is_in_group("player") && phase == 0):
		$Timer.start()

func process_phases():
	phase += 1
	match(phase):
		1:
			$AnimationPlayer.play("explosion1")
			$Sprite2D.global_position = $A1.global_position
			$Bridge.queue_free()
		2:
			$AnimationPlayer.play("explosion1")
			$Sprite2D.global_position = $A2.global_position
			$Bridge2.queue_free()
		3:
			$AnimationPlayer.play("explosion1")
			$Sprite2D.global_position = $A3.global_position
			$Bridge3.queue_free()
		4:
			queue_free()

func _on_animation_player_animation_finished(anim_name):
	process_phases()


func _on_timer_timeout():
	process_phases()
