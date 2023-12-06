extends Node2D

var currentOpt = 1
var maxOpt = 2

func _ready():
	pass # Replace with function body.

func _process(delta):
	if(Input.is_action_just_pressed("p1_select")):
		currentOpt += 1
		if(currentOpt > maxOpt):
			currentOpt = 1
		$UI/arrow.global_position.y = get_node("UI/Op"+str(currentOpt)).global_position.y
		Singleton.playerNumbers = currentOpt
	elif(Input.is_action_just_pressed("p1_start")):
		get_tree().change_scene_to_file("res://scenes/game.tscn")
