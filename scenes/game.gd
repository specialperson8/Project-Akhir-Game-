extends Node2D

var lives_p1 = 2
var lives_p2 = 2
var player1 = preload("res://scenes/player_1.tscn")
var player2 = preload("res://scenes/player_2.tscn")

var sfxScn = preload("res://scenes/sfx.tscn")

var score_p1 = 0
var score_p2 = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	respawnP1()
	if(Singleton.playerNumbers > 1):
		respawnP2()
	else:
		lives_p2 = 0
		
	updateLives()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func respawnP1():
	updateLives()	
	if(lives_p1 >= 0):
		var newPlayer = player1.instantiate()
		var lvl = get_tree().get_first_node_in_group("level")
		lvl.add_child(newPlayer)
		newPlayer.global_position = $SpawnPoint.global_position
	else:
		pass
		
func respawnP2():
	updateLives()
	if(lives_p2 >= 0):
		var newPlayer = player2.instantiate()
		var lvl = get_tree().get_first_node_in_group("level")
		lvl.add_child(newPlayer)
		newPlayer.global_position = $SpawnPoint.global_position
		var allPlayers = get_tree().get_nodes_in_group("player")
		for p in allPlayers:
			p.add_collision_exception_with(newPlayer.get_node("char"))
		
	else:
		pass

func updateLives():
	if(lives_p1 > 1):
		$"UI/P1-1".visible = true
		$"UI/P1-2".visible = true
	elif(lives_p1 == 1):
		$"UI/P1-1".visible = true
		$"UI/P1-2".visible = false
	else:
		$"UI/P1-1".visible = false
		$"UI/P1-2".visible = false
		
	if(lives_p2 > 1):
		$"UI/P2-1".visible = true
		$"UI/P2-2".visible = true
	elif(lives_p2 == 1):
		$"UI/P2-1".visible = true
		$"UI/P2-2".visible = false
	else:
		$"UI/P2-1".visible = false
		$"UI/P2-2".visible = false

func addNewLife_P1():
	lives_p1 += 1
	updateLives()

func setP1Score(num):
	score_p1 += num
	$UI/P1_Score.text = str(score_p1)
	
func setP2Score(num):
	score_p2 += num
	$UI/P2_Score.text = str(score_p2)
	
func createSFX(num):
	var newSfx = sfxScn.instantiate()
	var lvl = get_tree().get_first_node_in_group("level")
	lvl.add_child(newSfx)
	var newSound = load("res://BGM-SFX/Contra SFX (" + str(num) + ").wav" )
	newSfx.set_stream(newSound)
	newSfx.play()

func _on_dead_zone_body_entered(body):
	if(body.is_in_group("player")):
		body.death()
