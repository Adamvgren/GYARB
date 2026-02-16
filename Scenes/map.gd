extends Node2D

const PLAYER_SCENE = preload("res://Scenes/Player.tscn")


@onready var respawn_point: Node2D = $PlayerSpawnPos
var player: Player

func _ready() -> void:
	_spawn_player()
	$CanvasLayer3/Progressbarr/ProgressBar.player = player
	$CanvasLayer3/Progressbarr/ProgressBar.start_y = $PlayerSpawnPos.global_position.y



func _process(delta: float) -> void:
	pass

func _spawn_player() -> void:
	var p = PLAYER_SCENE.instantiate()
	p.global_position = respawn_point.global_position
	
	if p.has_signal("DEAD"):
		p.connect("DEAD", _on_player_dead)
	add_child(p)
	player = p
	

func respawn_player():
	var old_player = get_node_or_null("Player")
	if old_player:
		old_player.queue_free()
	_spawn_player()

func _on_player_dead() -> void:
	respawn_player()
