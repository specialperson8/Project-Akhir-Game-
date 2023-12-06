extends CharacterBody2D

const SPEED = 180.0
var alive = true

func _ready():
	var allPlayers = get_tree().get_nodes_in_group("player")
	for p in allPlayers:
		add_collision_exception_with(p)

func _physics_process(delta):
	var collision = move_and_slide()
	
	if(collision):
		for i in get_slide_collision_count():
			var collidedObj = get_slide_collision(i)
			if(collidedObj.get_collider().is_in_group("powerupcontainer")):
				collidedObj.get_collider().explodes()
				alive = false
				queue_free()
			elif(collidedObj.get_collider().is_in_group("enemy")):
				collidedObj.get_collider().death()
				var mainNode = get_tree().get_nodes_in_group("main")[0]
				if(is_in_group("id_p1")):
					mainNode.setP1Score(collidedObj.get_collider().points)
				else:
					mainNode.setP2Score(collidedObj.get_collider().points)
				queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func setVelocity(faceDirection):
	match(faceDirection):
		"Right":
			calcFinalVelocity(0)
		"Left":
			calcFinalVelocity(180)
		"Up":
			calcFinalVelocity(90)
		"Down":
			calcFinalVelocity(270)
		"RightUp":
			calcFinalVelocity(45)
		"RightDown":
			calcFinalVelocity(315)
		"LeftUp":
			calcFinalVelocity(135)
		"LeftDown":
			calcFinalVelocity(225)

func calcFinalVelocity(angle):
	var angle_in_radians = deg_to_rad(angle)
	velocity.x = SPEED * cos(angle_in_radians)
	velocity.y = SPEED * sin(angle_in_radians) * -1

func death():
	queue_free()
