extends Node2D

const SPEED = 180.0
# Called when the node enters the scene tree for the first time.
func _ready():
	get_child(0).calcFinalVelocity(0)
	get_child(3).calcFinalVelocity(45)
	get_child(1).calcFinalVelocity(315)
	get_child(2).calcFinalVelocity(330)
	get_child(4).calcFinalVelocity(60)
	
	var allBullets = get_tree().get_nodes_in_group("player_bullet")
	for b in allBullets:
		get_child(0).add_collision_exception_with(b)
		get_child(1).add_collision_exception_with(b)
		get_child(2).add_collision_exception_with(b)
		get_child(3).add_collision_exception_with(b)
		get_child(4).add_collision_exception_with(b)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
