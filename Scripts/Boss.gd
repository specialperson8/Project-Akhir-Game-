extends Node2D

var turret1 = 3
var turret2 = 3
var core = 10

var turn = true

var currentBullet = preload("res://scenes/bullet_enemy2.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_gun_body_entered(body):
	if(body.is_in_group("player_bullet")):
		turret1-=1
		if(turret1 == 0):
			$Gun.queue_free()

func _on_gun_2_body_entered(body):
	if(body.is_in_group("player_bullet")):
		turret2-=1
		if(turret2 == 0):
			$Gun2.queue_free()

func _on_core_body_entered(body):
	if(body.is_in_group("player_bullet")):
		if(turret1 > 0 || turret2 > 0):
			return
		core-=1
		if(core == 0):
			$Core.queue_free()
			$Barrier.queue_free()


func _on_timer_timeout():
	turn = !turn
	if(turn && turret1 > 0):
		var newBullet = currentBullet.instantiate()
		var lvl = get_tree().get_first_node_in_group("level")
		lvl.add_child(newBullet)
		for c in newBullet.get_child_count():
			newBullet.global_position = $Gun/Sp1.global_position
	elif(!turn && turret2 > 0):
		var newBullet = currentBullet.instantiate()
		var lvl = get_tree().get_first_node_in_group("level")
		lvl.add_child(newBullet)
		for c in newBullet.get_child_count():
			newBullet.global_position = $Gun2/Sp2.global_position


func _on_visible_on_screen_notifier_2d_screen_entered():
	$Timer.start()
