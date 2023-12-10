extends Camera2D

const SPEED = 7
const OFFSET = 25
var target = Vector2()
var end

# Called when the node enters the scene tree for the first time.
func _ready():
	target = global_position
	end = get_tree().get_nodes_in_group("end")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if(get_tree().get_current_scene().get_name() == "level1"):
			get_tree().change_scene_to_file("res://scenes/level2.tscn")
		elif(get_tree().get_current_scene().get_name() == "level2"):
			get_tree().change_scene_to_file("res://scenes/level3.tscn")
		elif(get_tree().get_current_scene().get_name() == "level3"):
			get_tree().change_scene_to_file("res://scenes/game.tscn")
	
