extends Area2D

var turret_active
var can_shot

var currentBullet = preload("res://scenes/bullet_enemy.tscn")

var lifes = 3

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(turret_active):
		var players = get_tree().get_nodes_in_group("player")
		if(players.size() > 1):
			if(abs(players[0].global_position.x - get_parent().global_position.x) < abs(players[1].global_position.x - get_parent().global_position.x)):
				$Sprite2D.look_at(players[1].global_position)
			else:
				$Sprite2D.look_at(players[0].global_position)
		elif(players.size() == 1 && players[0] != null):
			$Sprite2D.look_at(players[0].global_position)
		
		if(can_shot):
			shot()
			get_node("cooldown").start()
			
func shot():
	can_shot = false
	var newBullet = currentBullet.instantiate()
	var lvl = get_tree().get_first_node_in_group("level")
	lvl.add_child(newBullet)
	for c in newBullet.get_child_count():
		newBullet.get_child(c).calcFinalVelocity(-$Sprite2D.rotation_degrees)
		newBullet.global_position = $Sprite2D/Aim.global_position
	
func _on_cooldown_timeout():
	can_shot = true

func _on_visible_on_screen_notifier_2d_screen_entered():
	turret_active = true
	$cooldown.start()

func _on_body_entered(body):
	if(body.is_in_group("player_bullet")):
		lifes-= 1
		body.queue_free()
		if(lifes == 0):
			queue_free()
