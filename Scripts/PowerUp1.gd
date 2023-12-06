extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var clValue = 300
var powerType = 1

func _ready():
	generatePowerUp()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_on_floor():
		velocity.x = 0

	var collision = move_and_slide()
	
	if(collision):
		for i in get_slide_collision_count():
			var collidedObj = get_slide_collision(i)
			if(collidedObj.get_collider().is_in_group("player")):
				collidedObj.get_collider().currentBullet = collidedObj.get_collider().get("bulletP" + str(powerType))
				queue_free()
	
func setVelocity(xVelocity, yVelocity):
	velocity.x = clamp(xVelocity, -clValue, clValue)
	velocity.y = clamp(yVelocity, -clValue, clValue)
	

func generatePowerUp():
	randomize()
	powerType = randi_range(1,2)
	$Sprite2D.frame = powerType
