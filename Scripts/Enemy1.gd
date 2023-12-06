extends CharacterBody2D


const SPEED = 80.0
const JUMP_VELOCITY = -200.0
var currentVelocity
enum states {none, run, jump}
var currentState = states.none

var points = 20

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	velocity.x = -SPEED
	currentVelocity = velocity.x

func _physics_process(delta):
	
	velocity.x = currentVelocity
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if(currentState == states.run):
			decideAction()
	else:
		if(currentState == states.none):
			currentState = states.run

	var collision = move_and_slide()
	
	if(collision):
		for i in get_slide_collision_count():
			var collidedObj = get_slide_collision(i)
			if(collidedObj.get_collider().is_in_group("player")):
				collidedObj.get_collider().death()
			elif(collidedObj.get_collider().is_in_group("player_bullet")):
				collidedObj.get_collider().queue_free()
				var mainNode = get_tree().get_nodes_in_group("main")[0]
				if(collidedObj.get_collider().is_in_group("id_p1")):
					mainNode.setP1Score(points)
				else:
					mainNode.setP2Score(points)
				death()
	
func decideAction():
	randomize()
	if(randi_range(0,1) == 1):
		velocity.x = -velocity.x
		$Sprite2D.flip_h = !$Sprite2D.flip_h
		currentVelocity = velocity.x
	else:
		$AnimationPlayer.play("jump")
		velocity.y = JUMP_VELOCITY
		currentState = states.jump
		
func death():
	queue_free()
