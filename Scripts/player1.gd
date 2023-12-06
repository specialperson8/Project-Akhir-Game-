extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0

enum player_states {idle, run, jump, crouch, aimUp, water, dead}
var current_state = player_states.idle

var canShot = true

var normalBullet = preload("res://scenes/bullet_normal.tscn")
var bulletP1 = preload("res://scenes/bullet_p1.tscn")
var bulletP2 = preload("res://scenes/bullet_p2.tscn")

var currentBullet = normalBullet

var minCamera
var maxCamera

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction
var vDirection

func _ready():
	var allPlayers = get_tree().get_nodes_in_group("player")
	for p in allPlayers:
		add_collision_exception_with(p)
	var cam = get_tree().get_nodes_in_group("camera")
	minCamera = cam[0].get_node("min")
	maxCamera = cam[0].get_node("max")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() && current_state != player_states.water:
		velocity.y += gravity * delta
		if(current_state != player_states.dead):
			$AnimationPlayer.play("jump")
			current_state = player_states.jump
	else:
		get_tree().get_nodes_in_group("spawnPoint")[0].global_position.x = global_position.x

	# Handle Jump.
	if(current_state != player_states.dead):
		if Input.is_action_just_pressed("ui_accept") and (is_on_floor() || current_state == player_states.water):
			velocity.y = JUMP_VELOCITY
			current_state = player_states.jump

		direction = Input.get_axis("ui_left", "ui_right")
		vDirection = Input.get_axis("ui_up", "ui_down")
	
		if(vDirection):
			if is_on_floor():
				if vDirection > 0:
					if(current_state == player_states.idle):
						$AnimationPlayer.play("crouch")
						current_state = player_states.crouch
				else:
					if(current_state == player_states.idle):
						$AnimationPlayer.play("aim_up")
						current_state = player_states.aimUp
			elif current_state == player_states.water:
				if(vDirection > 0):
					$AnimationPlayer.play("swim_hide")
		else:
			if current_state == player_states.crouch || current_state == player_states.aimUp:
				current_state = player_states.idle
			
		if current_state != player_states.crouch && (current_state != player_states.water || !vDirection):
			if direction:
				velocity.x = direction * SPEED
				if is_on_floor():
					if(!vDirection):
						if(current_state != player_states.water):
							$AnimationPlayer.play("run")
							current_state = player_states.run
						else:
							$AnimationPlayer.play("swim")
					elif(current_state == player_states.water):
						$AnimationPlayer.play("swim")
					elif(vDirection > 0):
						$AnimationPlayer.play("down_right")
						current_state = player_states.run
					elif(vDirection < 0):
						$AnimationPlayer.play("up_right")
						current_state = player_states.run
				elif (current_state == player_states.water):
					if(!vDirection):
						$AnimationPlayer.play("swim")
				$spr.flip_h = (direction > 0)
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				if is_on_floor() && current_state != player_states.aimUp:
					if(current_state != player_states.water):
						$AnimationPlayer.play("idle")
						current_state = player_states.idle
					else:
						$AnimationPlayer.play("swim_idle")
				elif(current_state == player_states.water && !vDirection):
					$AnimationPlayer.play("swim_idle")

	if(global_position.x < minCamera.global_position.x && velocity.x < 0):
		velocity.x = 0	
	elif(global_position.x > maxCamera.global_position.x && velocity.x > 0):
		velocity.x = 0
	var collision = move_and_slide()
	
	if(current_state != player_states.dead):
		if(collision):
			for i in get_slide_collision_count():
				var collidedObj = get_slide_collision(i)
				if(collidedObj.get_collider().is_in_group("water")):
					current_state = player_states.water
				elif(collidedObj.get_collider().is_in_group("powerup")):
					currentBullet = get("bulletP" + str(collidedObj.get_collider().powerType))
					collidedObj.get_collider().queue_free()
				elif(collidedObj.get_collider().is_in_group("enemy") || collidedObj.get_collider().is_in_group("enemy_bullet")):
					death()
				
		if(Input.is_action_just_pressed("p1_shoot") && canShot):
			var newBullet = currentBullet.instantiate()
			var lvl = get_tree().get_first_node_in_group("level")
			lvl.add_child(newBullet)
			var faceDirection = getFacingDirection()
			if(currentBullet == normalBullet):
				get_tree().get_nodes_in_group("main")[0].createSFX(10)
			
			for c in newBullet.get_child_count():
				newBullet.get_child(c).setVelocity(faceDirection)
				newBullet.get_child(c).add_to_group("id_p1")
			newBullet.global_position = get_node("SpawnPositions/Aim_" + faceDirection).global_position
			canShot = false
			$Timer.start()


func getFacingDirection():
	var fDirection = ""
	
	if(!vDirection && !direction):
		if($spr.flip_h):
			fDirection = "Right"
		else:
			fDirection = "Left"
	elif(direction):
		if(direction > 0):
			fDirection = "Right"
		else:
			fDirection = "Left"
			
		if(vDirection):
			if(vDirection < 0):
				fDirection += "Up"
			else:
				fDirection += "Down"
	elif(vDirection):
		if(vDirection < 0):
			fDirection += "Up"
		else:
			fDirection += "Down"
			
	return fDirection

func _on_timer_timeout():
	canShot = true
	
func death():
	get_tree().get_nodes_in_group("main")[0].createSFX(18)
	$AnimationPlayer.play("death")
	current_state = player_states.dead
	velocity.x = 0
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	$Respawn.start()

func _on_respawn_timeout():
	var main = get_tree().get_nodes_in_group("main")[0]
	main.lives_p1 -= 1
	main.respawnP1()
	queue_free()
