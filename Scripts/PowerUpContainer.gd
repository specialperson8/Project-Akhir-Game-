extends CharacterBody2D

const SPEED = 100.0
var amplitude = 100.0
var elapsed_time = 0.0

var alive = true

var powerUp1 = preload("res://scenes/power_up_1.tscn")

func _physics_process(delta):
	velocity.x = -SPEED
	elapsed_time += delta
	
	var sine_wave = sin(elapsed_time / 0.1)
	velocity.y = sine_wave * amplitude

	var collision = move_and_slide()
	
	if(collision):
		for i in get_slide_collision_count():
			var collidedObj = get_slide_collision(i)
			if(collidedObj.get_collider().is_in_group("player_bullet")):
				explodes()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func explodes():
	if(!alive):
		return
	var newPowerUp = powerUp1.instantiate()
	var lvl = get_tree().get_first_node_in_group("level")
	lvl.add_child(newPowerUp)
	newPowerUp.setVelocity(velocity.x, velocity.y)
	newPowerUp.global_position = global_position
	alive = false
	queue_free()
