extends CharacterBody2D

const SPEED = 180.0
var alive = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	calcFinalVelocity(180)
	var allEnemy = get_tree().get_nodes_in_group("enemy")
	for p in allEnemy:
		add_collision_exception_with(p)
	var allPlatforms = get_tree().get_nodes_in_group("ground")
	for p in allPlatforms:
		add_collision_exception_with(p)


func _physics_process(delta):
	velocity.y += gravity * delta
	var collision = move_and_slide()
	
	if(collision):
		for i in get_slide_collision_count():
			var collidedObj = get_slide_collision(i)
			if(collidedObj.get_collider().is_in_group("player")):
				collidedObj.get_collider().death()
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
