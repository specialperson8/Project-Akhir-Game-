extends Area2D

var alive = true
var powerUp1 = preload("res://scenes/power_up_1.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if(body.is_in_group("player_bullet")):
		explodes()

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "opened"):
		$AnimationPlayer.play("opened_closed")
	elif(anim_name == "closed"):
		$AnimationPlayer.play("closed_opened")
	elif(anim_name == "opened_closed"):
		$AnimationPlayer.play("closed")
	elif(anim_name == "closed_opened"):
		$AnimationPlayer.play("opened")
		
func explodes():
	if(!alive || $AnimationPlayer.current_animation != "opened"):
		return
	var newPowerUp = powerUp1.instantiate()
	var lvl = get_tree().get_first_node_in_group("level")
	lvl.add_child(newPowerUp)
	newPowerUp.setVelocity(100, -300)
	newPowerUp.global_position = global_position
	alive = false
	queue_free()
