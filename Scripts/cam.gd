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
	if(global_position.x < end.global_position.x):
		global_position = lerp(global_position, target, delta*SPEED)

func _on_area_2d_body_entered(body):
	if(body.is_in_group("player")):
		target = Vector2(global_position.x + OFFSET, global_position.y)
